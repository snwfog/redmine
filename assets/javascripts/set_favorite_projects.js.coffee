$ ->
  $('tbody tr a').on 'ajax:success', (evt, data, status, xhr) ->
  $parentTr = $(this).parents('tr')
  if $parentTr.hasClass 'fav'
    $parentTr.removeClass('fav').addClass('unfav')
    $(this).data('method', 'delete')
    $(this).find('div.fav').removeClass('fav').addClass('unfav')
  else if $parentTr.hasClass 'unfav'
    $parentTr.removeClass('unfav').addClass('fav')
    $(this).data('method', 'post')
    $(this).find('div.unfav').removeClass('unfav').addClass('fav')