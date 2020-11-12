require 'rails_helper'

RSpec.describe  Mutations::InsuranceMutations::InsuranceUpdate, type: :request do
  describe '.resolve' do
    let(:operator) { create(:operator) }
    let(:agent) { create(:agent) }
    let(:insurance) { create(:insurance_life) }

    it 'update a insurance' do
      headers = {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}
      post '/graphql', params: { query: query(insurance.id) }, headers: headers
      insurance.reload
      expect(insurance.agency_name).to eq("test name")
    end

    it 'returns updated insurance' do
      post '/graphql', params: { query: query(insurance.id) }, headers: {'AUTHENTICATED-SCOPE': operator.user_role, 'AUTHENTICATED-USERID': operator.id}

      json = JSON.parse(response.body)
      data = json['data']['updateInsurance']
      expect(data).to include(
                          'id' => insurance.id,
                          'agencyName'  => 'test name',
                          'insuranceType' => insurance.insurance_type
                      )
    end

    context 'when authorized with agent user' do
      it 'returns error with permissions denied' do
        post '/graphql', params: { query: query(insurance.id) }, headers: {'AUTHENTICATED-SCOPE': agent.user_role, 'AUTHENTICATED-USERID': agent.id}
        json = JSON.parse(response.body)
        expect(json['errors'][0]['message']).to eq("Permission denied")
      end
    end
  end

  def query(id)
    <<~GQL
      mutation {
        updateInsurance(input: {
           agencyName: "test name" 
           id: #{id}
          }
        ) {
          id
          agencyName
          insuranceType
        }
      }
    GQL
  end
end