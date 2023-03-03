class Command::Purchase::CreateAgreement
  include Sidekiq::Job

  def perform(purchase_id)
    purchase = Purchase.find(purchase_id)
    agreement = create_internal_agreement(purchase)
    response = create_agreement_with_zepto(agreement, purchase)
    if response.ok?
      purchase.update(state: :pending_consent)
      Command::Agreement::CheckForApproval.perform_async(agreement.id)
    else
      purchase.update(state: :consent_failed)
    end
  end

  private

  def create_internal_agreement(purchase)
    Agreement.create!(
      purchase: purchase,
      zepto_agreement_id: Zepto::UIDGenerator.call,
      state: :awaiting_approval,
    )
  end

  def create_agreement_with_zepto(agreement, purchase)
    settlement_account = SettlementAccount.last
    Zepto.create_agreement(
      uid: agreement.zepto_agreement_id,
      debtor_account_name: purchase.account_name,
      debtor_branch_code: purchase.branch_code,
      debtor_account_number: purchase.account_number,
      creditor_account_name: settlement_account.account_name,
      creditor_branch_code: settlement_account.branch_code,
      creditor_account_number: settlement_account.account_number,
      amount: purchase.item.price_cents,
      description: purchase.item.title,
    )
  end
end
