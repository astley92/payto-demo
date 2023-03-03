RSpec.describe Command::Agreement::CheckForApproval do
  subject(:run_command) do
    described_class.perform_async(agreement.id)
  end

  before do
    Zepto.adapter._create_agreement!(uid: agreement.zepto_agreement_id, state: agreement_state_in_zepto)
  end

  let(:agreement) { create :agreement, purchase: purchase }
  let(:purchase) { create :purchase, item: create(:item) }
  let(:agreement_state_in_zepto) { :active }


  it "updates the agreement, purchase and enqueues the create payment job" do
    expect(Command::Purchase::CreatePayment).to receive(:perform_async).once

    run_command
    Command::Agreement::CheckForApproval.drain

    expect(agreement.reload.state).to eq("accepted")
    expect(purchase.reload.state).to eq("payment_processing")
  end

  context "when the agreement has not yet been approved" do
    before do
      Zepto._add_custom_response(
        :fetch_agreement,
        Zepto::Responses::Agreement.new(state: :pending),
      )
      Zepto._add_custom_response(
        :fetch_agreement,
        Zepto::Responses::Agreement.new(state: :pending),
      )
      Zepto._add_custom_response(
        :fetch_agreement,
        Zepto::Responses::Agreement.new(state: :active),
      )
    end

    it "re-enqueues itself until it receives a settled state" do
      expect(Command::Agreement::CheckForApproval).to receive(:perform_in).and_call_original.exactly(2).times

      run_command
      Sidekiq::Job.drain_all
    end
  end

  context "if the agreement does not get approved within the max amount of retries" do
    let(:agreement_state_in_zepto) { :something }

    it "does not enqueue itself indefinitely" do
      expect(Command::Agreement::CheckForApproval)
        .to receive(:perform_in)
        .and_call_original
        .exactly(Command::Agreement::CheckForApproval::MAX_RETRIES).times

      run_command
      Sidekiq::Job.drain_all
    end
  end
end
