var jUtils = {
    addEvent: function (el, event_name, callback) {
        var addHandler = function (elem) {
            if (elem.addEventListener) {
                elem.addEventListener(event_name, callback);
            } else if (elem.attachEvent) {
                elem.attachEvent('on' + event_name, function () {
                    callback.call(this.target || this.event.srcElement);
                });
            } else {
                elem[event_name] = callback;
            }
        };

        if (typeof el[0] !== 'undefined') {
            for (var i = 0; i < el.length; i++) {
                addHandler(el[i])
            }
        } else {
            addHandler(el)
        }
    },
    removeEvent: function (elem, event_name, callback) {
        if (elem.removeEventListener) {
            elem.removeEventListener(event_name, callback, false);
        } else if (elem.detachEvent) {
            elem.detachEvent('on' + event_name, callback);
        } else {
            elem[event_name] = null;
        }
    },
    findByClass: function (class_name) {
        if (document.getElementsByClassName) {
            return document.getElementsByClassName(class_name);
        }
        else {
            return document.querySelectorAll('.' + class_name);
        }
    },
    hasClass: function (elem, class_name) {
        if (elem.classList) {
            return elem.classList.contains(class_name);
        } else {
            return elem.className.split(/\s+/).find(class_name) !== -1;
        }
    },
    getEvent: function (e) {
        return e ? e : window.event;
    },
    fireEvent: function (element, event) {
        if (document.createEvent) {
            // dispatch for firefox + others
            var evt = document.createEvent("HTMLEvents");
            evt.initEvent(event, true, true); // event type,bubbling,cancelable
            return !element.dispatchEvent(evt);
        } else {
            // dispatch for IE
            return element.fireEvent('on' + event, document.createEventObject())
        }
    }
};
function bindDeleteLinks() {
    for (var i = 0, links = jUtils.findByClass('delete'); i < links.length; i++) {
        jUtils.addEvent(links[i], 'click', deleteRecord);
    }
    for (var a = 0, backs = document.getElementsByTagName('a'); a < backs.length; a++) {
        if (backs[a].innerHTML === 'Back') {
            jUtils.addEvent(backs[a], 'click', jumpBackOne);
        }
    }
}
function deleteRecord(e) {
    var ev = jUtils.getEvent(e);
    if (confirm(this.getAttribute('data-confirm') || 'You sure?')) {
        var form = document.createElement('form')
            , meth = document.createElement('input')
            , token = document.createElement('input');

        form.id = 'tempDestroyForm';
        form.method = 'post';
        form.action = this.href;
        meth.type = token.type = 'hidden';
        meth.name = '_method';
        meth.value = 'delete';
        token.name = 'authenticity_token';
        token.value = document.getElementsByName('csrf-token')[0].content;
        form.appendChild(meth);
        form.appendChild(token);
        document.body.appendChild(form);
        document.getElementById('tempDestroyForm').submit();
    }
    ev.stopPropagation();
    ev.preventDefault();
    return false;
}

function jumpBackOne(e) {
    var ev = jUtils.getEvent(e);
    if (window.history) {
        window.history.go(-1);
    } else {
        window.location.assign(this.href);
    }
    ev.stopPropagation();
    ev.preventDefault();
    return false;
}
;
/**
 * Created with JetBrains RubyMine.
 * User: ryanbuckley
 * Date: 8/2/13
 * Time: 8:39 PM
 * To change this template use File | Settings | File Templates.
 */


jUtils.addEvent(window, 'load', function () {
    bindDeleteLinks();
});



