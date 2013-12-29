var UP_KEY = 38
    , DOWN_KEY = 40;

$(function () {
    bindKeyUp();
});

function bindKeyUp() {

    $('.ctable').find('input')
        .on('keydown', function (e) {
            switch (e.keyCode) {
                case UP_KEY:
                    (new SpecialInput(this)).onUpKey();
                    return false;
                case DOWN_KEY:
                    (new SpecialInput(this)).onDownKey();
            }
        });
}

function SpecialInput(input_field) {
    this.input = input_field;

    this.findIndex = function () {
        return $(this.input).parent().parent().find('input[type=text]').index(this.input)
    };

    this.findLowerNeighbor = function () {
        return $(this.input).parent().parent().next().find('input[type=text]').get(this.findIndex());
    };

    this.findUpperNeighbor = function () {
        return $(this.input).parent().parent().prev().find('input[type=text]').get(this.findIndex());
    };

    this.onDownKey = function () {
        var target_input = this.findLowerNeighbor();

        if (target_input) {
            target_input.focus();
        }

    };

    this.onUpKey = function () {
        var target_input = this.findUpperNeighbor();

        if (target_input) {
            target_input.focus();
        }
    }
}
