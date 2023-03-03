class Command::Payment::CheckForSettlement
  include Sidekiq::Job
  sidekiq_options retry: 0

  MAX_RETRIES = 600


  def perform(payment_id, retry_count = 0)
    should_retry = true
    payment = Payment.find(payment_id)
    response = Zepto.fetch_payment(payment.zepto_payment_id)
    if response.ok?
      if response.state == :settled
        payment.update!(state: :settled)
        payment.purchase.update!(state: :complete)
        should_retry = false
      end
    else
      payment.purchase.update!(state: :payment_failed)
    end
    requeue(payment_id, retry_count) if (should_retry && retry_count < MAX_RETRIES)
  end

  private

  def requeue(payment_id, retry_count)
    Command::Payment::CheckForSettlement.perform_in(2.seconds, payment_id, retry_count + 1)
  end
end
