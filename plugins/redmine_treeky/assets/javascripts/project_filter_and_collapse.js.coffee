$ ->
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
