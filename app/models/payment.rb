# == Schema Information
#
# Table name: payments
#
#  id               :bigint           not null, primary key
#  state            :enum             not null
#  agreement_id     :bigint           not null
#  zepto_payment_id :string           not null
#  amount           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Payment < ApplicationRecord
  belongs_to :agreement
  has_one :purchase, through: :agreement

  enum state: {
    processing: "processing",
    failed: "failed",
    settled: "settled",
  }
end
