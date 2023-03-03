class Command::Agreement::CheckForApproval
  include Sidekiq::Job
  MAX_RETRIES = 600

  def perform(agreement_id, retry_count = 0)
    should_retry = true
    agreement = Agreement.find(agreement_id)
    response = Zepto.fetch_agreement(agreement.zepto_agreement_id)
    if response.ok?
      if response.state == :active
        should_retry = false
        agreement.update!(state: "accepted")
        agreement.purchase.update(state: "payment_processing")
        Command::Purchase::CreatePayment.perform_async(agreement.purchase.id)
      end
    else
      agreement.purchase.update!(state: :consent_failed)
    end

    if should_retry && retry_count < MAX_RETRIES
      requeue(agreement_id, retry_count)
    end
  end

  private

  def requeue(agreement_id, retry_count)
    Command::Agreement::CheckForApproval.perform_in(2.seconds, agreement_id, retry_count + 1)
  end
end
