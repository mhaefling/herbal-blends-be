require "rails_helper"

RSpec.describe ErrorSerializer, type: :serializer do
  describe "error_message" do
    let(:status) { 404 }
    let(:title) { "Error" }
    let(:message) { "Bad Request" }
    let(:detail) { "Invalid request parameters" }

    it 'structures an error message' do
      error = ErrorSerializer.error_message(status, title, message, detail)
      aggregate_failures do

        expect(error[:error]).to be_a(Hash)
        expect(error[:error][:status]).to eq("404")
        expect(error[:error][:title]).to eq("Error")
        expect(error[:error][:message]).to eq("Bad Request")
        expect(error[:error][:detail]).to eq("Invalid request parameters")
      end
    end
  end
end