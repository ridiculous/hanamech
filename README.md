= Cuz you know what it do what it does

== Date chores needed to upgrade to V2
    Customer.all.map { |c| c.set_name;c.save }
    Car.all.map { |c| c.year_make_model = c.name; c.save }