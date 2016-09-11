# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(super_admin geengo_admin firm_admin work_council_admin infrastructure_admin).each do |role_name|
  Role.find_or_create_by_name(:name => role_name)
end

j = Admin.find_or_create_by_email(:email => "julien@cruxandco.com", :password => "sdfsdf")
max = Admin.find_or_create_by_email(:email => "mmoulin@geengo.fr", :password => "sdfsdf")

j.roles = [Role.find_by_name("geengo_admin")]
max.roles = [Role.find_by_name("geengo_admin")]