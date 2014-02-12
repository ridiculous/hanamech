var utils = {
    isNumeric: function (value) {
        return !isNaN(parseFloat(value.toString().replace(/,/, '').replace(/(?!^)-/g, '')));
    },
    pureAmount: function (amount) {
        return amount.toString().replace(/[^0-9.-]/g, '').replace(/(?!^)-/g, '');
    }
};


$(function () {

    partsCalculator();
    laborCalculator();
    totalCalculator();

    $('#workorder_date').datepicker();
    $('.part-name').autocomplete({
        source: BOOTSTRAP.part_names
    });

    $('.job-name').autocomplete({
        source: BOOTSTRAP.job_names
    });

    $('.customer-name').one('click', function () {
        var name = this;
        if (Site.Cache.customersLoaded()) {
            bindAutocomplete(name, Site.Cache.getCustomers());
        } else {
            $.getJSON('/customers', function (data) {
                Site.Cache.save('customers', data);
                bindAutocomplete(name, data)
            })
        }
    });

    function bindAutocomplete(field, data) {
        $(field).autocomplete({
            source: data.map(function (item) {
                return item.name
            })
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

    function partsCalculator() {
        var $ph = $('#total_parts, #workorder_parts_total')
            , $table = $('.parts-section').find('.ctable');

        $table.find('.part-price, .part-quantity')
            .on('keyup', function () {
                $ph.val(sumUp($table.find('tr').toArray()).toFixed(2)).trigger('change')
            });

        function sumUp(rows) {
            for (var i = 0, val = 0.0; i < rows.length; i++) {
                var quantity = $('.part-quantity', rows[i]).val()
                    , unit_price = $('.part-price', rows[i]).val();
                if (unit_price && quantity && !isNaN(quantity) && utils.isNumeric(unit_price)) {
                    val += parseFloat(utils.pureAmount(quantity)) * parseFloat(utils.pureAmount(unit_price));
                }
            }
            return val;
        }
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
                var labor_val = $inputs[i].value
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
