# Here is some comments lol
$ ->
  $('.list tbody').sortable
    stop: (event, ui) ->
      $(this).parents('table').redrawTableStrip()
      thisFieldId = ui.item.data('field-id')
      position = $(this).sortable('toArray').indexOf("field_#{thisFieldId}") + 1
      $.ajax
        type: "PUT"
        url: "/custom_fields/#{thisFieldId}"
        data:
          insert_at: position


    handle: "span.dnd-handle"
    cursor: "-webkit-grabbing"

  # Mouse cursor behaviour
  $('span.dnd-handle').mouseenter (event) ->
    classProp = $(this).prop 'class'
    ($(this).prop 'class', classProp + " mouseover") unless (/mouseover/.test classProp)

  removeMouseOver = (event) ->
    classProp = $(event.target).prop 'class'
    if (/mouseover/.test classProp)
      $(event.target).prop 'class', (classProp.replace /\s+mouseover/, '')

  $('span.dnd-handle').mousedown removeMouseOver
  $('span.dnd-handle').mouseleave removeMouseOver

$.fn.redrawTableStrip = ->
  alt = 1
  this.find('tbody tr:not(tr.hide)').each ->
    classProp = $(this).prop('class')
    classProp = classProp.replace(/(even|odd)/, "")
    classProp += if ((alt++) % 2) == 0 then " even" else " odd"
    $(this).prop('class', classProp)
