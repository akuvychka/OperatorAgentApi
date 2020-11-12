require 'rails_helper'

RSpec.describe  Mutations::ContractMutations::ContractUpdate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }
    let(:agent) { create(:agent) }
    let(:contract) { create(:contract) }
    let(:insurance_property) { create(:insurance_property) }

    it 'update a contract' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      post '/graphql', params: { query: query(contract.id, insurance_property.id) }, headers: headers
      contract.reload
      expect(contract.insurance).to eq(insurance_property)
    end

    it 'returns updated contract' do
      post '/graphql', params: { query: query(contract.id, insurance_property.id) }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['updateContract']
      expect(data).to include(
                          'id' => be_present,
                          'user'  => { 'id' => contract.user.id},
                          'client' => { 'id' => contract.client.id },
                          'insurance' => {'id' => insurance_property.id}
                      )
    end

    context 'when authorized with agent user' do
      it 'update a contract' do
        post '/graphql', params: { query: query(contract.id, insurance_property.id) }, headers: {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        contract.reload
        expect(contract.insurance).to eq(insurance_property)
      end
    end
  end

  def query(id, insurance_id)
    <<~GQL
      mutation {
        updateContract(input: {
           id: #{id}
           insuranceId: #{insurance_id}
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