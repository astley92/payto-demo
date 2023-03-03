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
FactoryBot.define do
  factory :payment do
    state { "processing" }
    zepto_payment_id { "my_id" }
    amount { 123 }
  end
end
