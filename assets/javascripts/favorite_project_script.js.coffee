$ ->
  # Handles expanding and collapsing project expander
  # by issueing a custom events that the expander will
  # be listening to depending on whether it is showing
  # the full projects or only the favorite projects
  $('span.expander').on 'click', (event) ->
    if ($('#only-favorite-projects').hasClass('all'))
      $(this).trigger('clickRegular')
    else
      $(this).trigger('clickFavorite')

  # Click handler that will show all projects
  expandRegular = (event) ->
    if ($(this).parents('tr').hasClass('open'))
      $(this).collapseExpander()
    else
      $(this).expandExpander()
    $('table').redrawTableStrip()

  # Click handler that will show only favorite projects
  expandFavorite = (event) ->
    if ($(this).parents('tr').hasClass('open'))
      $(this).collapseExpander({favorite: true})
    else
      $(this).expandExpander({favorite: true})
    $('table').redrawTableStrip()

  $.fn.collapseExpander = (options) ->
    defaults =
      favorite: false
      bubbling: false
    settings = $.extend({}, defaults, options)

    $tr = this.parents('tr')
    $tr.removeClass('open').addClass('closed')
    if $tr.isParent()
      projectId = $tr.getProjectId()
      # Select all children expander to collapse their projects
      fav = if settings.favorite then ".fav" else ""
#      if settings.bubbling
#        selector = "tr.open.parent.#{projectId}"
#        $("#{selector}#{fav} span.expander").each ->
#          $(this).collapseExpander(options)
      unless settings.bubbling
        $("tr:visible.#{projectId}#{fav}").hide()

  $.fn.expandExpander = (options) ->

    defaults =
      favorite: false
      bubbling: false
    settings = $.extend({}, defaults, options)

    $tr = this.parents('tr')
    $tr.removeClass('closed').addClass('open') unless $tr.hasClass('open')
    projectId = $tr.getProjectId()
    parentLevel = $tr.getProjectLevel()
    # Select all children expander to collapse their projects
    fav = if settings.favorite then ".fav" else ""
    $("tr:hidden.#{projectId}#{fav}[data-project-level=#{parentLevel+1}]").each ->
      if $(this).isParent() && $(this).hasClass('open')
        $(this).find('span.expander').expandExpander(options)
      $(this).show()

#    if settings.bubbling
#      $("tr.closed.parent.#{projectId}#{fav} span.expander").each ->
#        $(this).expandExpander(options)
#      $("tr.parent.#{projectId}#{fav}").show()
#    else
#      # Get only parent first sub level projects and show them
#      parentFirstSubLevelProject = $.grep($("tr.#{projectId}#{fav}"), (el, index) ->
#        $(el).level() == parentLevel + 1)
#      $.each(parentFirstSubLevelProject, (index, el) ->
#        $(el).show())

  # Handles success/failure of fav/unfav projects
  $('tbody tr form').on('ajax:success', (evt, data, status, xhr) ->
    $tr = $(this).parents('tr')
    $submitType = $(this).find('input[name="_method"]')
    if $tr.hasClass 'fav'
      # Remove this tr from the view if we are in favorite only view
      if $('#only-favorite-projects').hasClass('fav')
        $tr.hide()
        # Check if this tr has showing siblings
        $parentProjectTr = $tr.parentProjectTr() if $tr.hasParentProject()
        # True checks fav project only
        if $parentProjectTr? and not $parentProjectTr.hasVisibleChildProject(true)
          $parentProjectTr.find('span.expander').off('clickFavorite').addClass('dummy')
      # Removing favorite tr class
      $tr.removeClass('fav').addClass('unfav')
      $(this).find('input[type="submit"]').removeClass('fav').addClass('unfav')
      $submitType.attr('value', 'post') if $submitType?
      # Figure out this parent level
      $(this).parents("tr").tagChildren($tr.getProjectLevel()) if $tr.isParent()
    else if $tr.hasClass 'unfav'
      # Adding favorite
      $tr.removeClass('unfav').addClass('fav')
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

  $.fn.getProjectLevel = ->
    this.data('project-level')

  $.fn.getProjectId = ->
    this.data('project-id')

  $.fn.fav = ->
    this.removeClass('unfav').addClass('fav')

  $.fn.unfav = ->
    this.removeClass('fav').addClass('unfav')

  $.fn.isFav = ->
    this.hasClass 'fav'

  $.fn.isUnfav = ->
    this.hasClass 'unfav'

  $.fn.isParent = ->
    return true if this.hasClass 'parent'
    return true if this.parents('tr').hasClass 'parent'
    return false

  $.fn.hasParentProject = ->
    this.data('project-level') > 0

  $.fn.parentProjectTr = ->
    parentIds = this.attr('class').match(/[\d]+/g)
    return undefined unless parentIds?
    closestParentId = parentIds.reverse()[0]
    return $("tr##{closestParentId}span")

  $.fn.tagChildren = (level) ->
    projectId = this.getProjectId()
    els = $.grep $("tr.fav.#{projectId}"), (el) ->
      return $(el).getProjectLevel() == level + 1
    $.each els, (index, el) ->
      $(el).find('form').submit() if $(this).isFav()

  $.fn.tagParent = ->
    $el = this
    klazz = $el.parents('tr').attr('class')
    parents = klazz.match /[\d]+/g
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
    if ($anchor.hasClass('all'))
      # Toggle event listener
      $('span.expander').off('clickRegular')
      $('span.expander').on('clickFavorite', expandFavorite)
      $anchor.removeClass('all').addClass('fav')
      $anchor.html("Show all projects")
      $('#collapse-expand-all-projects').hide()
      $('#projects-list tbody tr').each ->
        if $(this).hasClass('fav') then $(this).show() else $(this).hide()
        if $(this).hasClass 'parent'
          $(this).addClass('open').removeClass('closed')
          # Check if there are favorites child project
          unless $(this).hasVisibleChildProject(true)
            $(this).find('span.expander').off('clickFavorite').addClass('dummy')
    else if ($anchor.hasClass('fav'))
      # Toggle event listener
      $('span.expander').off('clickFavorite')
      $('span.expander').on('clickRegular', expandRegular)

      $anchor.removeClass('fav').addClass('all')
      $anchor.html("Only favorites")
      $('#collapse-expand-all-projects').show()
      $('#projects-list tbody tr').each ->
        $(this).show()
        if ($(this).isParent())
          $(this).addClass('open').removeClass('closed')
          $(this).find('span.expander').removeClass('dummy')
      $('#collapse-expand-all-projects').html("Collapse all")
      $('#collapse-expand-all-projects').removeClass('collapsed').addClass('expanded')
    $('table').redrawTableStrip()

  $.fn.hasVisibleChildProject = (favorite = false) ->
    fav = if favorite then ".fav" else ""
    projectId = this.data('project-id')
    projectLevel = this.data('project-level')
    $("tr:visible.#{projectId}#{fav}[data-project-level=#{projectLevel + 1}]").exists()

  $.fn.redrawTableStrip = ->
    alt = 1;
    this.find('tbody tr:visible').each ->
      $(this).removeClass('even odd')
      klass = if ((alt++)%2) == 0 then "even" else "odd"
      $(this).addClass(klass)

  $('span.expander').on('clickRegular', expandRegular)
  $('#only-favorite-projects').trigger('click')
  $('.project-custom-label-filter').trigger('change')
