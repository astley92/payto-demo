class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_enum(
      :purchases_state,
      %w[
        created
        pending_consent
        payment_processing
        complete
        consent_failed
        payment_failed
      ]
    )

    create_table :purchases do |t|
      t.references :item, foreign_key: true, null: false
      t.string :account_name, null: false
      t.string :branch_code, null: false
      t.string :account_number, null: false
      t.enum :state, enum_type: :purchases_state
      t.timestamps
    end
  end
end
