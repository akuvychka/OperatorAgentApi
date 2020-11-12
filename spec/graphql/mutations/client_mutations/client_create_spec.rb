require 'rails_helper'

RSpec.describe  Mutations::ClientMutations::ClientCreate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }

    it 'creates a client' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      expect do
        post '/graphql', params: { query: query }, headers: headers
      end.to change { Client.count }.by(1)
    end

    it 'returns a new client' do
      post '/graphql', params: { query: query }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['createClient']
      expect(data).to include(
                          'id' => be_present,
                          'name'  => 'test name',
                          'email' => 'email@email.email',
                          'surname'=> "test surname"
                      )
    end

    context 'when authorized with agent user' do
      let(:agent) { create(:agent) }
      it 'creates a client' do
        headers = {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        expect do
          post '/graphql', params: { query: query }, headers: headers
        end.to change { Client.count }.by(1)
      end
    end
  end

  def query
    <<~GQL
      mutation {
        createClient(input: {
           email: "email@email.email"
           name: "test name" 
           surname: "test surname"
          }
        ) {
          id
          name
          email
          surname
        }
      }
    GQL
  end
end