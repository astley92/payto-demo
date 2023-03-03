# == Schema Information
#
# Table name: purchases
#
#  id             :bigint           not null, primary key
#  item_id        :bigint           not null
#  account_name   :string           not null
#  branch_code    :string           not null
#  account_number :string           not null
#  state          :enum
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Purchase < ApplicationRecord
  after_update_commit -> {
    broadcast_replace_to(
      "purchase_#{self.id}",
      target: "purchase-information",
      partial: "purchases/purchase_information",
      locals: { purchase: self }
    )
  }

  belongs_to :item
  has_one :agreement

  enum state: {
    created: "created",
    pending_consent: "pending_consent",
    payment_processing: "payment_processing",
    complete: "complete",
    consent_failed: "consent_failed",
    payment_failed: "payment_failed",
  }
end
