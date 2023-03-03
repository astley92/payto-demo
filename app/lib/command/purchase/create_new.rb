class Command::Purchase::CreateNew < ActiveInteraction::Base
  integer :item_id
  string :account_number
  string :branch_code
  string :account_name

  validates :branch_code, length: { minimum: 6, maximum: 6 }
  validates :account_number, presence: true
  validates :account_name, presence: true
  validate :settlement_account_is_configured

  def execute
    Purchase.create!(
      item_id: item_id,
      account_number: account_number,
      branch_code: branch_code,
      account_name: account_name,
      state: :created,
    )
  end

  private

  def settlement_account_is_configured
    return unless SettlementAccount.count < 1

    errors.add(:base, "There is no settlement account configured.")
  end
end
