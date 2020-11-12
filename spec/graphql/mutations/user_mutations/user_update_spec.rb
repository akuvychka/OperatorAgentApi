require 'rails_helper'

RSpec.describe  Mutations::UserMutations::UserUpdate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }
    let(:agent) { create(:agent) }

    it 'update a user' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      post '/graphql', params: { query: query(agent.id) }, headers: headers
      agent.reload
      expect(agent.name).to eq("test name")
    end

    it 'returns updated user' do
      post '/graphql', params: { query: query(agent.id) }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['updateUser']
      expect(data).to include(
                          'id' => agent.id,
                          'name'  => 'test name',
                          'email' => agent.email
                      )
    end

    context 'when authorized with agent user' do
      let(:agent) { create(:agent) }
      it 'returns error with permissions denied' do
        post '/graphql', params: { query: query(operator.id) }, headers: {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        json = JSON.parse(response.body)
        expect(json['errors'][0]['message']).to eq("Permission denied")
      end
    end
  end

  def query(id)
    <<~GQL
      mutation {
        updateUser(input: {
           name: "test name" 
           id: #{id}
          }
        ) {
          id
          name
          email
        }
      }
    GQL
  end
end