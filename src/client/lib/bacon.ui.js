(function() {
  "use strict";

  Bacon.UI = {};

  Bacon.UI.textFieldValue = function(textfield) {
    var getValue;
    return getValue = function() {
      return textfield.val();
    };
  };

  $(textfield).asEventStream("keyup input").merge($(textfield).asEventStream("cut paste").delay(1)).map(getValue).skipDuplicates().toProperty(getValue());

  Bacon.UI.optionValue = function(option) {
    var getValue;
    return getValue = function() {
      return option.val();
    };
  };

  option.asEventStream("change").map(getValue).toProperty(getValue());

  Bacon.UI.checkBoxGroupValue = function(checkboxes, initValue) {
    var selectedValues;
    return selectedValues = function() {
      return checkboxes.filter(":checked").map(function(i, elem) {
        return $(elem).val();
      }).toArray();
    };
  };

  if (initValue) {
    checkboxes.each(function(i, elem) {
      return $(elem).attr("checked", initValue.indexOf($(elem).val()) >= 0);
    });
  }

  checkboxes.asEventStream("click").map(selectedValues).toProperty(selectedValues());

  Bacon.Observable.prototype.pending = function(src) {
    return src.map(true).merge(this.map(false)).toProperty(false);
  };

  Bacon.EventStream.prototype.ajax = function() {
    return this["switch"](function(params) {
      return Bacon.fromPromise($.ajax(params));
    });
  };

}).call(this);
