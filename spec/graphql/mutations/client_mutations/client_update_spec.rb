require 'rails_helper'

RSpec.describe  Mutations::ClientMutations::ClientUpdate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }
    let(:agent) { create(:agent) }
    let(:client) { create(:client) }

    it 'update a client' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      post '/graphql', params: { query: query(client.id) }, headers: headers
      client.reload
      expect(client.name).to eq("test name")
    end

    it 'returns updated client' do
      post '/graphql', params: { query: query(client.id) }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['updateClient']
      expect(data).to include(
                          'id' => client.id,
                          'name'  => 'test name',
                          'email' => client.email
                      )
    end

    context 'when authorized with agent user' do
      it 'update a client' do
        post '/graphql', params: { query: query(client.id) }, headers: {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        client.reload
        expect(client.name).to eq("test name")
      end
    end
  end

  def query(id)
    <<~GQL
      mutation {
        updateClient(input: {
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