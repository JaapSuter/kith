"use strict";

Bacon.UI = {}

Bacon.UI.textFieldValue = (textfield) ->
    getValue = ->
      textfield.val()
$(textfield).asEventStream("keyup input").merge($(textfield).asEventStream("cut paste").delay(1)).map(getValue).skipDuplicates().toProperty getValue()

Bacon.UI.optionValue = (option) ->
  getValue = ->
    option.val()
option.asEventStream("change").map(getValue).toProperty getValue()

Bacon.UI.checkBoxGroupValue = (checkboxes, initValue) ->
  selectedValues = ->
    checkboxes.filter(":checked").map((i, elem) ->
      $(elem).val()
    ).toArray()
if initValue
  checkboxes.each (i, elem) ->
    $(elem).attr "checked", initValue.indexOf($(elem).val()) >= 0

checkboxes.asEventStream("click").map(selectedValues).toProperty selectedValues()

Bacon.Observable::pending = (src) ->
  src.map(true).merge(@map(false)).toProperty false

Bacon.EventStream::ajax = ->
  @switch (params) ->
    Bacon.fromPromise $.ajax(params)