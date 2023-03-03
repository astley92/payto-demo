class CreateAgreements < ActiveRecord::Migration[7.0]
  def change
    create_enum(:agreement_states, %w[awaiting_approval declined accepted])
    create_table :agreements do |t|
      t.enum :state, enum_type: :agreement_states, null: false
      t.references :purchase, null: false
      t.string :zepto_agreement_id, null: false
      t.timestamps
    end
  end
end
