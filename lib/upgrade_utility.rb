#= Workorder Mixin
# Data manipulations needed to upgrade to Version 2

module UpgradeUtility

  def convert_to_v2
    destroy && return if car.nil?
    do_parts if workorder_parts.empty?
    do_jobs if workorder_jobs.empty?
    self.tax_total = tax.to_f
    self.labor_total = labor.to_f
    self.paid_in_advance = 0.0
    self.balance_due = total.to_f
    save!
  end

  def do_parts
    wo_mats = split(materials)
    len = wo_mats.length
    wo_mats.each do |mats|
      build_workorder_parts(mats, len)
    end
  end

  def do_jobs
    wo_details = split(details)
    len = wo_details.length
    wo_details.each do |dets|
      build_workorder_jobs(dets, len)
    end
  end

  # periods that are not followed by a number and comma or carriage return and new line
  def split(str)
    str.split(/\.+(?=[^0-9])|[,\r\n]/).reject { |s| s.blank? || s == '.' }.map { |s| s.gsub(/\s+/, ' ').strip.downcase }
  end

  def build_workorder_parts(mats, len)
    qt = get_quantity(mats)
    price = len == 1 ? parts_total : 0.0
    name = mats.sub(Regexp.new("#{qt} "), '')
    return unless name.present?
    part = Part.find_or_initialize_by(name: name)
    unless part.persisted?
      part.price = price
      part.save
    end
    workorder_parts.create(part: part, quantity: qt, price: price)
  end

  def build_workorder_jobs(dets, len)
    price = len == 1 ? labor : 0.0
    job = Job.find_or_initialize_by(name: dets)
    unless job.persisted?
      job.hours = 1
      job.save
    end
    workorder_jobs.create(job: job, total: price, hours: 1)
  end

  def get_quantity(mats)
    if mats =~ /^(\d{1})\s/ # single digit = quantity
      $1
    else
      '1'
    end
  end
end