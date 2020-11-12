require 'rails_helper'

RSpec.describe  Mutations::ClientMutations::ClientDestroy, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }
    let(:agent) { create(:agent) }
    let(:client) { create(:client) }

    it 'destroy a client' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      id = client.id
      expect do
        post '/graphql', params: { query: query(id) }, headers: headers
      end.to change { Client.count }.by(-1)
    end

    context 'when authorized with agent user' do
      it 'returns error with permissions denied' do
        post '/graphql', params: { query: query(client.id) }, headers: {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        json = JSON.parse(response.body)
        expect(json['errors'][0]['message']).to eq("Permission denied")
      end
    end
  end

  def query(id)
    <<~GQL
      mutation {
        destroyClient(input: {
           id: #{id}
          }
        ) {
          id
        }
      }
    GQL
  end
end