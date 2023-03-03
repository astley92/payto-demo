# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  title          :string           not null
#  price_cents    :integer          not null
#  image_filename :string           not null
#
FactoryBot.define do
  factory :item do
    title { "Default Title" }
    price_cents { 123 }
    image_filename { "default_image.png" }
  end
end
