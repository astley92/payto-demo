# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

SettlementAccount.find_or_create_by!(account_name: "Blake Astley", account_number: "66928680", branch_code: "923100")
Item.find_or_create_by!(title: "Zeptoghini", price_cents: 1, image_filename: "lambo.png", description: "0 to 100 in a zeptosecond")
Item.find_or_create_by!(title: "Zeptinghouse Smart Fridge", price_cents: 1, image_filename: "fridge.png", description: "100 to 0 in a zeptosecond")
