class CreateSettlementAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :settlement_accounts do |t|
      t.string :account_name, null: false
      t.string :account_number, null: false
      t.string :branch_code, null: false
      t.timestamps
    end
  end
end
