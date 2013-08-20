$ ->

  # Handles success/failure of fav/unfav projects
  $('tbody tr form').on('ajax:success', (evt, data, status, xhr) ->
    $parentTr = $(this).parents('tr')
    $submitType = $(this).find('input[name="_method"]')
    if $parentTr.hasClass 'fav'
      # Removing favorite tr class
      $parentTr.removeClass('fav').addClass('unfav')
      $(this).find('input[type="submit"]').removeClass('fav').addClass('unfav')
      $submitType.attr('value', 'post') if $submitType?
    else if $parentTr.hasClass 'unfav'
      # Adding favorite
      $parentTr.removeClass('unfav').addClass('fav')
      unless $submitType.exists()
        $submitType = $('<input>').attr('name', '_method').attr('type', 'hidden')
        $(this).find('div').prepend($submitType)
      $submitType.attr('value', 'delete')
      $(this).find('input[type="submit"]').removeClass('unfav').addClass('fav')
      $(this).tagParent()
  ).bind('ajax:failure', (evt, data, status, xhr) ->
    console.log "Something went horribly wrong. And it's all Charles' faults"
  )

  $.fn.tagParent = ->
    $el = this
    klazz = $el.parents('tr').attr('class')
    parents = klazz.match /[\d]{4}/g
    if parents
      closestParent = parents.reverse()[0]
      console.group("Flagging parent span #{closestParent}")
      $tr = $("tr##{closestParent}span")
      console.log($tr.get(0))
      $tr.find('form').submit() unless $tr.hasClass('fav')
      console.groupEnd()

  $.fn.exists = ->
    this.length != 0;

  $('.project-custom-label-filter').change (e) ->
      $(this).find('input[type=checkbox]').each ->
        classId = $(this).data('field')
        $td = $("#projects-list .custom-field-" + classId)
        if ($(this).is(':checked')) then $td.css("display", "") else $td.css("display", "none")
      $(this).submit();

  $('#collapse-expand-all-projects').on 'click', (e) ->
    e.preventDefault()
    $anchor = $(this)
    if ($anchor.hasClass('expanded'))
      $anchor.addClass('collapsed').removeClass('expanded')
      $('tr.open.parent span.expander').toggleExpander()
      $anchor.html("Expand All")
    else if ($anchor.hasClass('collapsed'))
      $anchor.addClass('expanded').removeClass('collapsed')
      $('tr.closed.parent span.expander').toggleExpander()
      $anchor.html("Collapse All")
    $('tbody tr:not(tr.hide)').redrawTableStrip()

  $('#only-favorite-projects').on 'click', (e) ->
    e.preventDefault()
    $anchor = $(this)
    if ($anchor.hasClass('all'))
      $anchor.removeClass('all').addClass('fav')
      $anchor.html("Show All Projects")
      $('tr.closed.parent span.expander').toggleExpander()
      $('#collapse-expand-all-projects').css({'display': 'none'})
      $('tr span.expander').hide()
      $('#projects-list tbody tr').each ->
        $(this).removeClass('hide') if $(this).hasClass('fav')
        $(this).addClass('hide') unless $(this).hasClass('fav')
##        if $(this).hasClass 'fav'
##          $(this).removeClass('fav').addClass('hide')
#        else if $(this).hasClass 'hide'
#          $(this).removeClass('hide').addClass('fav')
    else if ($anchor.hasClass('fav'))
      $anchor.removeClass('fav').addClass('all')
      $anchor.html("Only Favorites")
      $('tr span.expander').show()
      $('#collapse-expand-all-projects').css({'display': ''})
      $('#projects-list tbody tr').each ->
        $(this).removeClass('hide')
      $('tr.closed.parent span.expander').toggleExpander()
      $('#collapse-expand-all-projects').html("Collapse All")
      $('#collapse-expand-all-projects').removeClass('collapsed').addClass('expanded')
    $('tbody tr:not(tr.hide)').redrawTableStrip()

  $.fn.toggleExpander = ->
    this.each ->
      if typeof this.onclick == 'function'
        this.onclick.call()

  $.fn.redrawTableStrip = ->
    alt = 1;
    this.find('tbody tr:not(tr.hide)').each ->
      $(this).removeClass('even odd')
      klass = ((alt++) %2) == 0 ? "even" : "odd"
      $(this).addClass(klass)

  $('#only-favorite-projects').trigger('click')
  $('.project-custom-label-filter').trigger('change')
