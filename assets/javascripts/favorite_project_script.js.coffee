$ ->
  # Handles expanding and collapsing project
  $('span.expander').on 'click', (event) ->
    if ($('#only-favorite-projects').hasClass('all'))
      $(this).trigger('click.regular')
    else
      $(this).trigger('click.favorite')

  expandRegular = (event) ->
    if ($(this).parents('tr').hasClass('open'))
      $(this).collapseExpander()
    else
      $(this).expandExpander()
    $('table').redrawTableStrip()

  expandFavorite = (event) ->
    console.log("Expanding favorites only...")

  $.fn.collapseExpander = ->
    $tr = this.parents('tr')
    $tr.removeClass('open').addClass('closed')
    projectId = $tr.attr('id').match(/[\d]{4}/)
    # Select all children expander to collapse their projects
    $("tr.open.parent.#{projectId} span.expander").each ->
      $(this).collapseExpander()
    $("tr.child.#{projectId}").hide()
    $parentProjects = $("tr.parent.closed.#{projectId}")
    if ($parentProjects.exists())
      $parentProjects.each ->
        $(this).hide()

  $.fn.expandExpander = ->
    $tr = this.parents('tr')
    $tr.removeClass('closed').addClass('open')
    projectId = $tr.attr('id').match(/[\d]{4}/)
    # Select all children expander to collapse their projects
    $("tr.closed.parent.#{projectId} span.expander").each ->
      $(this).expandExpander()
    $("tr.child.#{projectId}").show()
    $parentProjects = $("tr.parent.open.#{projectId}")
    if ($parentProjects.exists())
      $parentProjects.each ->
        $(this).show()

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
    $('table').redrawTableStrip()

  $('#only-favorite-projects').on 'click', (e) ->
    e.preventDefault()
    $anchor = $(this)
    if ($anchor.hasClass('all'))
      $anchor.removeClass('all').addClass('fav')
      $anchor.html("Show All Projects")
#      $('tr.closed.parent span.expander').toggleExpander()
      $('#collapse-expand-all-projects').hide()
      $('#projects-list tbody tr').each ->
        $(this).removeClass('hide') if $(this).hasClass('fav')
        $(this).addClass('hide') unless $(this).hasClass('fav')

      $('span.expander').off('click.regular')
      $('span.expander').on('click.favorite', expandFavorite)
    else if ($anchor.hasClass('fav'))
      $anchor.removeClass('fav').addClass('all')
      $anchor.html("Only Favorites")
      $('#collapse-expand-all-projects').show()
      $('#projects-list tbody tr').each ->
        $(this).removeClass('hide')
#      $('tr.closed.parent span.expander').toggleExpander()
      $('#collapse-expand-all-projects').html("Collapse All")
      $('#collapse-expand-all-projects').removeClass('collapsed').addClass('expanded')
      $('span.expander').off('click.favorite')
      $('span.expander').on('click.regular', expandRegular)
    $('table').redrawTableStrip()

  $.fn.toggleExpander = ->
    this.each ->
      if typeof this.onclick == 'function'
        this.onclick.call()

  $.fn.redrawTableStrip = ->
    alt = 1;
    this.find('tbody tr:not(tr.hide)').each ->
      $(this).removeClass('even odd')
      klass = if ((alt++)%2) == 0 then "even" else "odd"
      $(this).addClass(klass)

  $('#only-favorite-projects').trigger('click')
  $('.project-custom-label-filter').trigger('change')
