module Zepto::AdapterInterface
  def create_agreement(
      uid:,
      debtor_account_name:,
      debtor_branch_code:,
      debtor_account_number:,
      creditor_account_name:,
      creditor_branch_code:,
      creditor_account_number:,
      amount:,
      description:
    )
  end

  def create_payment(uid:, amount:, agreement_uid:, description:); end
  def fetch_agreement(agreement_id); end
  def fetch_payment(payment_id); end
end
