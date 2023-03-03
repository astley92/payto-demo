RSpec.describe Command::Payment::CheckForSettlement do
  subject(:run_command) do
    described_class.perform_async(payment.id)
  end

  before do
    Zepto.adapter._create_payment!(uid: payment.zepto_payment_id, state: payment_state_in_zepto)
  end

  let(:payment) { create :payment, agreement: agreement }
  let(:agreement) { create :agreement, purchase: purchase }
  let(:purchase) { create :purchase, item: create(:item) }
  let(:payment_state_in_zepto) { :settled }


  it "updates the payment and purchase" do
    run_command
    Command::Payment::CheckForSettlement.drain

    expect(payment.reload.state).to eq("settled")
    expect(purchase.reload.state).to eq("complete")
  end

  context "when the payment has not yet settled" do
    before do
      Zepto._add_custom_response(
        :fetch_payment,
        Zepto::Responses::Payment.new(state: :something),
      )
      Zepto._add_custom_response(
        :fetch_payment,
        Zepto::Responses::Payment.new(state: :something),
      )
      Zepto._add_custom_response(
        :fetch_payment,
        Zepto::Responses::Payment.new(state: :settled),
      )
    end

    it "re-enqueues itself until it receives a settled state" do
      expect(Command::Payment::CheckForSettlement).to receive(:perform_in).and_call_original.exactly(2).times

      run_command
      Sidekiq::Job.drain_all
    end
  end

  context "if the payment does not settle within the max amount of retries" do
    let(:payment_state_in_zepto) { :something }

    it "does not enqueue itself indefinitely" do
      expect(Command::Payment::CheckForSettlement)
        .to receive(:perform_in)
        .and_call_original
        .exactly(Command::Payment::CheckForSettlement::MAX_RETRIES).times

      run_command
      Sidekiq::Job.drain_all
    end
  end
end
