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
FactoryBot.define do
  factory :agreement do
    state { "awaiting_approval" }
    zepto_agreement_id { "default agreement" }
  end
end
