# Here is some comments lol
$ ->
  $('.list tbody').sortable
    stop: (event, ui) ->
      $(this).parents('table').redrawTableStrip()


$.fn.redrawTableStrip = ->
  alt = 1
  this.find('tbody tr:not(tr.hide)').each ->
    classProp = $(this).prop('class')
    classProp = classProp.replace(/(even|odd)/, "")
    classProp += if ((alt++) % 2) == 0 then " even" else " odd"
    $(this).prop('class', classProp)
