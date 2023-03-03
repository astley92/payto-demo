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
FactoryBot.define do
  factory :purchase do
    state { "created" }
    account_name { "Default Name" }
    branch_code { "123456" }
    account_number { "123456" }
  end
end
