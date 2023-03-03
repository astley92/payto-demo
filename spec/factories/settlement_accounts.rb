# == Schema Information
#
# Table name: settlement_accounts
#
#  id             :bigint           not null, primary key
#  account_name   :string           not null
#  account_number :string           not null
#  branch_code    :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :settlement_account do
    account_name { "Default Name" }
    branch_code { "123456" }
    account_number { 654321 }
    created_at { Time.now - 10.years }
  end
end
