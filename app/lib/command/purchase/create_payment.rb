class Command::Purchase::CreatePayment
  include Sidekiq::Job

  def perform(purchase_id)
    agreement = Agreement.find_by(purchase_id: purchase_id)
    payment = create_internal_payment(agreement)
    response = Zepto.create_payment(
      agreement_uid: agreement.zepto_agreement_id,
      uid: payment.zepto_payment_id,
      amount: payment.amount,
      description: agreement.purchase.item.title,
    )
    if response.ok?
      Command::Payment::CheckForSettlement.perform_async(payment.id)
    else
      Purchase.update(purchase_id, state: :payment_failed)
    end
  end

  private

  def create_internal_payment(agreement)
    Payment.create!(
      agreement_id: agreement.id,
      zepto_payment_id: Zepto::UIDGenerator.call,
      state: :processing,
      amount: agreement.purchase.item.price_cents,
    )
  end
end
