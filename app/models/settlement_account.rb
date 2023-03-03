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
class SettlementAccount < ApplicationRecord
end
