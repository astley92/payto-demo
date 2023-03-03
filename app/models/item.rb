# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  title          :string           not null
#  price_cents    :integer          not null
#  image_filename :string           not null
#
class Item < ApplicationRecord
  has_many :purchases

  def formatted_price
    dollars = price_cents / 100
    cents = price_cents % 100
    "$#{dollars.to_s}.#{cents.to_s.rjust(2, "0")}"
  end
end
