$ ->
  # Handles expanding and collapsing project
  $('span.expander').on 'click', (event) ->
    if ($('#only-favorite-projects').hasClass('all'))
      $(this).trigger('clickRegular')
    else
      $(this).trigger('clickFavorite')

  expandRegular = (event) ->
    if ($(this).parents('tr').hasClass('open'))
      $(this).collapseExpander()
    else
      $(this).expandExpander()
    $('table').redrawTableStrip()

  expandFavorite = (event) ->
    if ($(this).parents('tr').hasClass('open'))
      $(this).collapseExpander({favorite: true})
    else
      $(this).expandExpander({favorite: true})
    $('table').redrawTableStrip()

  $.fn.collapseExpander = (options) ->
    defaults =
      favorite: false
    settings = $.extend({}, defaults, options)

    $tr = this.parents('tr')
    $tr.removeClass('open').addClass('closed')
    projectId = $tr.attr('id').match(/[\d]{4}/)
    # Select all children expander to collapse their projects
    selector = "tr.open.parent.#{projectId}"
    fav = if settings.favorite then ".fav" else ""
    $("#{selector}#{fav} span.expander").each ->
      $(this).collapseExpander(options)
    $("tr.child.#{projectId}#{fav}").hide()
    $parentProjects = $("tr.parent.closed.#{projectId}#{fav}")
    if ($parentProjects.exists())
      $parentProjects.each ->
        $(this).hide()

  $.fn.expandExpander = (options) ->

    defaults =
      favorite: false
    settings = $.extend({}, defaults, options)

    $tr = this.parents('tr')
    $tr.removeClass('closed').addClass('open')
    projectId = $tr.attr('id').match(/[\d]{4}/)
    # Select all children expander to collapse their projects
    fav = if settings.favorite then ".fav" else ""
    $("tr.closed.parent.#{projectId}#{fav} span.expander").each ->
      $(this).expandExpander(options)
    $("tr.child.#{projectId}#{fav}").show()
    $parentProjects = $("tr.parent.open.#{projectId}#{fav}")
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
      # Keep tagging parent even if this tr might already be favorited
      $(this).tagParent()
  ).bind('ajax:failure', (evt, data, status, xhr) ->
    console.log "Something went horribly wrong. And it's all Charles' faults"
  )

  $.fn.tagParent = ->
    $el = this
    klazz = $el.parents('tr').attr('class')
    parents = klazz.match /[\d]{4}/g
    if parents
      # Find next parent that is unfavorited
      closestUnfavParents = $.grep parents.reverse(), (parentId, index) ->
        $el = $("tr.unfav##{parentId}span")
        return $el.exists()
      # Take the first parent tr which is the closest
      $("tr.unfav##{closestUnfavParents[0]}span").find('form').submit() if (closestUnfavParents.length > 0)
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
      $('tr.parent.open span.expander').each ->
        $(this).collapseExpander()
      $anchor.html("Expand all")
    else if ($anchor.hasClass('collapsed'))
      $anchor.addClass('expanded').removeClass('collapsed')
      $('tr.parent.closed span.expander').each ->
        $(this).expandExpander()
      $anchor.html("Collapse all")
    $('table').redrawTableStrip()

  $('#only-favorite-projects').on 'click', (e) ->
    e.preventDefault()
    $anchor = $(this)
    $('a.collapsed').trigger('click') unless $('a.expanded').exists()
    if ($anchor.hasClass('all'))
      $anchor.removeClass('all').addClass('fav')
      $anchor.html("Show all projects")
      $('#collapse-expand-all-projects').hide()
      $('#projects-list tbody tr').each ->
        if $(this).hasClass('fav') then $(this).show() else $(this).hide()
      $('span.expander').off('clickRegular')
      $('span.expander').on('clickFavorite', expandFavorite)
    else if ($anchor.hasClass('fav'))
      $anchor.removeClass('fav').addClass('all')
      $anchor.html("Only favorites")
      $('#collapse-expand-all-projects').show()
      $('#projects-list tbody tr').each ->
        $(this).show()
      $('#collapse-expand-all-projects').html("Collapse all")
      $('#collapse-expand-all-projects').removeClass('collapsed').addClass('expanded')
      $('span.expander').off('clickFavorite')
      $('span.expander').on('clickRegular', expandRegular)
    $('table').redrawTableStrip()

  $.fn.toggleExpander = ->
    this.each ->
      if typeof this.onclick == 'function'
        this.onclick.call()

  $.fn.redrawTableStrip = ->
    alt = 1;
    this.find('tbody tr:visible').each ->
      $(this).removeClass('even odd')
      klass = if ((alt++)%2) == 0 then "even" else "odd"
      $(this).addClass(klass)

  $('#only-favorite-projects').trigger('click')
  $('.project-custom-label-filter').trigger('change')