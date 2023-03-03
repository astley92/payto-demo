# == Schema Information
#
# Table name: agreements
#
#  id                 :bigint           not null, primary key
#  state              :enum             not null
#  purchase_id        :bigint           not null
#  zepto_agreement_id :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Agreement < ApplicationRecord
  belongs_to :purchase
  has_one :payment

  enum state: {
    awaiting_approval: "awaiting_approval",
    declined: "declined",
    accepted: "accepted",
  }
end
