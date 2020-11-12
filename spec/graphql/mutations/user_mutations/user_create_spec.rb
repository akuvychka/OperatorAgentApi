require 'rails_helper'

RSpec.describe  Mutations::UserMutations::UserCreate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }

    it 'creates a user' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      expect do
        post '/graphql', params: { query: query([operator.id]) }, headers: headers
      end.to change { User.count }.by(1)
    end

    it 'returns a new user' do
      post '/graphql', params: { query: query([operator.id]) }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['createUser']
      expect(data).to include(
                          'id' => be_present,
                          'name'  => 'test name',
                          'email' => 'email@email.email',
                          'contacts'          => [{ 'email' => operator.email }]
                      )
    end

    context 'when authorized with agent user' do
      let(:agent) { create(:agent) }
      it 'returns error with permissions denied' do
        post '/graphql', params: { query: query([operator.id]) }, headers: {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        json = JSON.parse(response.body)
        expect(json['errors'][0]['message']).to eq("Permission denied")
      end
    end
  end

  def query(contacts)
    <<~GQL
      mutation {
        createUser(input: {
           email: "email@email.email"
           name: "test name" 
           userRole: "operator"
           contacts: #{contacts}
          }
        ) {
          id
          name
          email
          contacts {
            email
          }
        }
      }
    GQL
  end
end