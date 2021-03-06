module WorkordersHelper

  def materials_list(mats)
    if mats.blank?
      content_tag(:li, "None")
    else
      mats.split(/, /).collect { |mat| content_tag :li, mat }.join
    end
  end

  def my_new_wo_path
    set_customer_mode
    if in_customer_mode
      new_car_workorder_path(@car)
    else
      new_workorder_path
    end
  end

  def my_wo_path(wo=@workorder)
    set_customer_mode
    if in_customer_mode
      car_workorder_path(@car, wo)
    else
      workorder_path(wo)
    end
  end

  def edit_my_wo_path(wo=@workorder)
    set_customer_mode
    if in_customer_mode
      edit_car_workorder_path(@car, wo)
    else
      edit_workorder_path(wo)
    end
  end

  def my_wos_path
    set_customer_mode
    if in_customer_mode
      car_workorders_path(@car)
    else
      workorders_path
    end
  end

  def format_amount(amt, prefix = '')
    return if amt.blank?
    amt = amt.to_s
    if amt =~ /^[\d.,\s-]+$/
      "#{prefix}%.2f" % Float(amt.tr(',', ''))
    else
      amt
    end
  end
end
