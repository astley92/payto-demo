require("./spec/shared_examples/zepto")

RSpec.describe Zepto::RealAdapter do
  subject(:adapter) { described_class.new }
  it_behaves_like "a zepto adapter"

  describe ".create_agreement" do
    let(:params) do
      {
        uid: "so_unique_3",
        debtor_account_name: "Erlich Bachman",
        debtor_branch_code: "123456",
        debtor_account_number: "876543",
        creditor_account_name: "Jian Yang",
        creditor_branch_code: "654321",
        creditor_account_number: "876342",
        amount: 123,
        description: "Test agreement",
      }
    end

    it "returns a GenericSuccess object" do
      VCR.use_cassette("zepto/create_agreement/success") do
        expect(adapter.create_agreement(**params)).to be_a(Zepto::Responses::GenericSuccess)
      end
    end

    context "when the request fails" do
      before { params[:uid] = "not valid" }

      it "returns a GenericFailure object" do
        VCR.use_cassette("zepto/create_agreement/failure") do
          expect(adapter.create_agreement(**params)).to be_a(Zepto::Responses::GenericFailure)
        end
      end
    end
  end

  describe ".create_payment" do
    let(:params) do
      {
        uid: "so_unique_3",
        agreement_uid: "so_unique_3",
        amount: 123,
        description: "Test Payment"
      }
    end

    it "returns a GenericSuccess object" do
      VCR.use_cassette("zepto/create_payment/success") do
        expect(adapter.create_payment(**params)).to be_a(Zepto::Responses::GenericSuccess)
      end
    end

    context "when the request fails" do
      before { params[:uid] = "not valid" }

      it "returns a GenericFailure object" do
        VCR.use_cassette("zepto/create_payment/failure") do
          expect(adapter.create_payment(**params)).to be_a(Zepto::Responses::GenericFailure)
        end
      end
    end
  end

  describe ".fetch_agreement" do
    let(:agreement_id) { "so_unique_3" }

    it "returns a AgreementStateCheck object" do
      VCR.use_cassette("zepto/fetch_agreement/success/cancelled") do
        response = adapter.fetch_agreement(agreement_id)
        expect(response).to be_a(Zepto::Responses::Agreement)
        expect(response.state).to eq(:cancelled)
      end
    end

    context "when the request fails" do
      let(:agreement_id) { "i_dont_exist" }

      it "returns a GenericFailure object" do
        VCR.use_cassette("zepto/fetch_payment/failure") do
          response = adapter.fetch_payment(agreement_id)
          expect(response).to be_a(Zepto::Responses::GenericFailure)
        end
      end
    end
  end

  describe ".fetch_payment" do
    let(:payment_id) { "so_unique_3" }

    it "returns a PaymentStateCheck object" do
      VCR.use_cassette("zepto/fetch_payment/success/settled") do
        response = adapter.fetch_payment(payment_id)
        expect(response).to be_a(Zepto::Responses::Payment)
        expect(response.state).to eq(:settled)
      end
    end

    context "when the request fails" do
      let(:payment_id) { "i_dont_exist" }

      it "returns a GenericFailure object" do
        VCR.use_cassette("zepto/fetch_payment/failure") do
          response = adapter.fetch_payment(payment_id)
          expect(response).to be_a(Zepto::Responses::GenericFailure)
        end
      end
    end
  end
end
