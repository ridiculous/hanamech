# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

customer = Customer.create!(name: 'Ryan Buckley', phone_number: '18082647381', street: '121 Longname St', city_state: 'Martinez, HI')
user = User.new(email: 'arebuckley@gmail.com', luna: true)
car = customer.cars.create!(:year => 2014,
                            :engine_size => 2,
                            :vin_number => "4444badass55577",
                            :year_make_model => "2014 VW Jetta SE")
user.customer = customer
user.password = user.password_confirmation = 'access'
user.save!

