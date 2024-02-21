# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#NetballEducator.destroy_all
NetballEducator.create([
{first_name: "Jenna"},
{last_name: "Jones"},
{email: "jjones@gmail.com"},
{phone: "1314555676"},
{school_name: "Hillview High School"},
{city: "Houston"},
{state: "TX"}, 
{educator_notes: "Callback for equipment"}, 
{mgmt_notes: "Spoke at meeting"}, 
])


p "Created #{NetballEducator.count} educators"

