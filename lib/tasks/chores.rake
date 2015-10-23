namespace :chores do
  desc 'Upgrade to version 2'
  task upgrade: :environment do
    puts '-> Updating Customers'
    Customer.find_each do |c|
      c.set_name
      c.phone_number = c.cell_number if c.phone_number.blank?
      c.save
    end
    puts '-> Updating Cars'
    Car.find_each do |c|
      c.year_make_model = c.name
      c.save
    end
    puts '-> Updating Workorders'
    Workorder.find_each { |wo| wo.convert_to_v2 }
    puts '-> Done :)'
  end

  task record_count: :environment do
    count = Workorder.count
    count += User.count
    count += Car.count
    count += Customer.count
    count += Part.count
    count += Job.count
    count += WorkorderJob.count
    count += WorkorderPart.count
    puts "-> #{count}"
  end

  desc 'Fill in form indices for workorder jobs'
  task populate_form_indices: :environment do
    Workorder.select('id').each do |workorder|
      workorder.workorder_jobs.each_with_index do |job, i|
        job.update_attribute(:form_index, i)
      end
    end
  end
end