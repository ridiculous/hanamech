module CarsHelper

  def my_edit_car_path(car=@car)
    set_customer_mode
    if in_customer_mode
      edit_customer_car_path(@customer, car)
    else
      edit_car_path(car)
    end
  end

  def my_new_car_path
    set_customer_mode
    if in_customer_mode
      new_customer_car_path(@customer)
    else
      new_car_path
    end
  end

  def my_car_path(car=@car)
    set_customer_mode
    if in_customer_mode
      customer_car_path(@customer, car)
    else
      car_path(car)
    end
  end

  def my_cars_path
    set_customer_mode
    if in_customer_mode
      customer_cars_path(@customer)
    else
      cars_path
    end
  end
end
