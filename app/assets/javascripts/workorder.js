function bindWorkOrderHelper() {
    var total = document.getElementById('workorder_total')
        , items = jUtils.findByClass('factored')
        , pureAmount = function (amount) {
            var ramt = amount.toString().replace(/[^0-9.-]/g, '').replace(/(?!^)-/g, '');
            if (ramt) {
                return parseFloat(ramt);
            } else {
                return 0;
            }
        }
        , onFactorKeyup = function (e) {
            var amt = 0.0;
            for (var a = 0; a < items.length; a++) {
                amt += parseFloat(pureAmount(items[a].value));
            }
            total.value = amt ? Math.round(amt * 100) / 100 : '';
        };

    for (var i = 0; i < items.length; i++) {
        jUtils.addEvent(items[i], 'keyup', onFactorKeyup)
    }
}