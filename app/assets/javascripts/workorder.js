var utils = {
    isNumeric: function (value) {
        return !isNaN(parseFloat(value.toString().replace(/,/, '').replace(/(?!^)-/g, '')));
    },
    pureAmount: function (amount) {
        return amount.toString().replace(/[^0-9.-]/g, '').replace(/(?!^)-/g, '');
    }
};


$(function () {

    var $PART_TOTALS = $('#total_parts, #workorder_parts_total');

    partsTotal();
    partsCalculator();
    laborCalculator();
    totalCalculator();
    partsAutocomplete();
    jobsAutocomplete();
    carsAutocomplete();

    $('.customer-name').one('click', function () {
        var name = this;
        if (Site.cache.customersLoaded()) {
            customersAutocomplete(name, Site.cache.getCustomers());
        } else {
            $.getJSON('/customers', function (data) {
                Site.cache.save('customers', data);
                customersAutocomplete(name, data)
            })
        }
    });

    function partsAutocomplete() {
        setTimeout(function () {
            $.getJSON('/parts', function (data) {
                var parts = data;
                $('.part-name').autocomplete({
                    source: parts.map(function (item) {
                        return item.name
                    }),
                    select: function (e, obj) {
                        var part = parts.findObject(obj.item.value, 'name');
                        $(this.parentElement.parentElement).find('.part-price').val(part.price);
                    }
                });
            })
        }, 50);
    }

    function jobsAutocomplete() {
        setTimeout(function () {
            $.getJSON('/jobs', function (data) {
                var jobs = data;
                $('.job-name').autocomplete({
                    source: jobs.map(function (item) {
                        return item.name
                    }),
                    select: function (e, obj) {
                        var hours = jobs.findObject(obj.item.value, 'name').hours;
                        $(this.parentElement.parentElement).find('.hours-total').val(hours);
                    }
                });
            })
        }, 275);
    }

    function carsAutocomplete() {
        setTimeout(function () {
            $.getJSON('/cars', function (data) {
                var cars = data;
                $('#year_make_model').autocomplete({
                    source: cars.map(function (item) {
                        return item.year_make_model
                    }),
                    select: function (e, obj) {
                        var car = cars.findObject(obj.item.value, 'year_make_model');
                        if (car.engine_size) {
                            document.getElementById('car_engine_size').value = car.engine_size;
                        }
                        if (car.vin_number) {
                            document.getElementById('car_vin').value = car.vin_number;
                        }
                        if (car.odometer) {
                            document.getElementById('workorder_odometer').value = car.odometer;
                        }
                    }
                });
            })
        }, 550);
    }

    function customersAutocomplete(field, data) {
        $(field).autocomplete({
            source: data.map(function (item) {
                return item.name
            }),
            select: function (e, obj) {
                var customer = Site.cache.getCustomers().findObject(obj.item.value, 'name');

                if (customer.street) {
                    document.getElementById('customer_street').value = customer.street;
                }

                if (customer.city_state) {
                    document.getElementById('customer_city_state').value = customer.city_state;
                }

                if (customer.phone_number) {
                    document.getElementById('customer_phone').value = customer.phone_number;
                }
            }
        });
    }

    function totalCalculator() {
        var $ph = $('#workorder_total')
            , $paid = $('#workorder_paid_in_advance')
            , $balance = $('#workorder_balance_due')
            , $parts = $('.part-of-total')
            , calcTotal = function () {
                for (var i = 0, total = 0.0; i < $parts.length; i++) {
                    var val = $parts[i].value;
                    if (val && utils.isNumeric(val)) {
                        total += parseFloat(val);
                    }
                }
                return total;
            },
            setTotal = function () {
                $ph.val(calcTotal().toFixed(2)).trigger('change');
            },
            setBalanceDue = function () {
                var paid = $paid.val(),
                    total = $ph.val()
                if (paid && utils.isNumeric(paid) && total && utils.isNumeric(total)) {
                    $balance.val((parseFloat(utils.pureAmount(total)) - parseFloat(utils.pureAmount(paid))).toFixed(2))
                }
            };

        $parts
            .on('change', setTotal)
            .on('blur', setTotal);

        $ph.on('change', setBalanceDue);

        $paid.on('keyup', setBalanceDue);

    }

    function partsTotal() {
        $PART_TOTALS.on('keyup', function () {
            $PART_TOTALS.not('#' + this.id).val(this.value);
        });
    }

    function partsCalculator() {
        var $table = $('.parts-section').find('.ctable');

        $table.find('.part-price, .part-quantity')
            .on('keyup', function () {
                $PART_TOTALS.val(sumUpRows($table.find('tr').toArray()).toFixed(2)).trigger('change')
            });

    }

    function sumUpRows(rows) {
        for (var i = 0, val = 0.0; i < rows.length; i++) {
            var quantity = $('.part-quantity', rows[i]).val()
                , unit_price = $('.part-price', rows[i]).val();
            if (unit_price && quantity && !isNaN(quantity) && utils.isNumeric(unit_price)) {
                val += parseFloat(utils.pureAmount(quantity)) * parseFloat(utils.pureAmount(unit_price));
            }
        }
        return val;
    }

    function laborCalculator() {
        var $ph = $('#workorder_labor_total'),
            $table = $('.ctable'),
            $inputs = $table.find('.labor-total');

        $inputs.on('keyup', function () {
            $ph.val(sumTotal().toFixed(2)).trigger('change');
        });

        $table.find('.hours-total').on('keyup', function () {
            $ph.val(sumTotal().toFixed(2)).trigger('change');
        });

        function sumTotal() {
            var total = 0.0;

            for (var i = 0; i < $inputs.length; i++) {
                var labor_val = $inputs[i].value;
                if (labor_val && utils.isNumeric(labor_val)) {
                    var hours_val = $($inputs[i].parentElement.parentElement).find('.hours-total').val();
                    if (hours_val && utils.isNumeric(hours_val)) {
                        total += parseFloat(labor_val) * parseFloat(hours_val);
                    }
                }
            }

            return total;
        }
    }

});
