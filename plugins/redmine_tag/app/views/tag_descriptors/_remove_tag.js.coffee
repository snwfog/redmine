$ ->
  $('#tag-edit-cloud .remove').on('ajax:success', (e, data, status, xhr) ->
    $(this).parents('li').remove()
  ).bind("ajax:error", (e, data, status, xhr) ->
    alert "Could not find this tag."
  )


