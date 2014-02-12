var Site = {
    Cache: {
        getStorage: function () {
            if (typeof localStorage == 'object') {
                return localStorage;
            } else if (typeof globalStorage == 'object') {
                return globalStorage[location.host];
            } else
                return {};
        },

        get: function (key) {
            return this.getStorage()[key];
        },

        customersLoaded: function () {
            return typeof this.get('customers') === 'string';
        },

        getCustomers: function () {
            return JSON.parse(this.get('customers'));
        },

        save: function (key, data) {
            this.getStorage()[key] = JSON.stringify(data);
        },

        clear: function (key) {
            return delete this.getStorage()[key];
        }
    }
};