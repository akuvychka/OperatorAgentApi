require 'rails_helper'

RSpec.describe  Mutations::ContractMutations::ContractCreate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }
    let(:agent) { create(:agent) }
    let(:client) { create(:client) }
    let(:insurance) { create(:insurance_life) }

    it 'creates a contract' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      expect do
        post '/graphql', params: { query: query(insurance.id, client.id, agent.id) }, headers: headers
      end.to change { Contract.count }.by(1)
    end

    it 'returns a new contract' do
      post '/graphql', params: { query: query(insurance.id, client.id, agent.id) }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['createContract']
      expect(data).to include(
                          'id' => be_present,
                          'user'  => { 'id' => agent.id},
                          'client' => { 'id' => client.id },
                          'insurance' => { 'id' => insurance.id}
                      )
    end

    context 'when authorized with agent user' do
      it 'creates a contract' do
        headers = {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        expect do
          post '/graphql', params: { query: query(insurance.id, client.id, agent.id) }, headers: headers
        end.to change { Contract.count }.by(1)
      end
    end
  end

  def query(insurance_id, client_id, agent_id)
    <<~GQL
      mutation {
        createContract(input: {
           insuranceId: #{insurance_id}
           clientId: #{client_id}
           userId: #{agent_id}
          }
        ) {
          id
          user {
            id
          }
          client {
            id
          }
          insurance {
            id
          }
        }
      }
    GQL
  end
end