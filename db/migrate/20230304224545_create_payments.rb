class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_enum(:payment_states, %w[processing failed settled])
    create_table :payments do |t|
      t.enum :state, enum_type: :payment_states, null: false
      t.references :agreement, null: false
      t.string :zepto_payment_id, null: false
      t.integer :amount, null: false
      t.timestamps
    end
  end
end
