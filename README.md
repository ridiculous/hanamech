Cuz you know what it do what it does
========

Date chores needed to upgrade to V2
============

    Customer.all.each { |c| c.set_name;c.save(validate: false) };nil
    Car.all.each { |c| c.year_make_model = c.name; c.save };nil
    Workorder.all.map(&:convert_to_v2)

TODO
===========

* Add jQuery autocomplete to customer, parts, and jobs for workorders