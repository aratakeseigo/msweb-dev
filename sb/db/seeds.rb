# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
InternalUser.destroy_all
InternalUser.create!(email: "test1@example.com", password: "password", login_id: "test", name: "テスト　太郎")
InternalUser.create!(email: "test2@example.com", password: "password", login_id: "test2", name: "テスト　承認")
