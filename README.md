Cuz you know what it do what it does
========

Date chores needed to upgrade to V2
============

    Customer.find_each { |c| c.set_name;c.phone_number = c.cell_number if c.phone_number.blank?;c.save };nil
    Car.find_each { |c| c.year_make_model = c.name; c.save };nil
    Workorder.all.map(&:convert_to_v2)

TODO
===========

* Add jQuery autocomplete to customer, parts, and jobs for workorders