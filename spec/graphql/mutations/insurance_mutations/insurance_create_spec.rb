require 'rails_helper'

RSpec.describe  Mutations::InsuranceMutations::InsuranceCreate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }

    it 'creates a insurance' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      expect do
        post '/graphql', params: { query: query }, headers: headers
      end.to change { Insurance.count }.by(1)
    end

    it 'returns a new insurance' do
      post '/graphql', params: { query: query }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['createInsurance']
      expect(data).to include(
                          'id' => be_present,
                          'agencyName'  => 'Test',
                          'insuranceType' => 'life'
                      )
    end

    context 'when authorized with agent user' do
      let(:agent) { create(:agent) }
      it 'returns error with permissions denied' do
        headers = {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        post '/graphql', params: { query: query }, headers: headers
        json = JSON.parse(response.body)
        expect(json['errors'][0]['message']).to eq("Permission denied")
      end
    end
  end

  def query
    <<~GQL
      mutation {
        createInsurance(input: { agencyName: "Test", insuranceType: "life", totalCost: 980.00, period: "annual"}) {
          id
          agencyName
          insuranceType
        }
      }
    GQL
  end
end