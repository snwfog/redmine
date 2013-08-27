// Generated by CoffeeScript 1.6.2
(function() {
  $(function() {
    var expandFavorite, expandRegular;

    $('span.expander').on('click', function(event) {
      if ($('#only-favorite-projects').hasClass('all')) {
        return $(this).trigger('clickRegular');
      } else {
        return $(this).trigger('clickFavorite');
      }
    });
    expandRegular = function(event) {
      if ($(this).parents('tr').hasClass('open')) {
        $(this).collapseExpander();
      } else {
        $(this).expandExpander();
      }
      return $('table').redrawTableStrip();
    };
    expandFavorite = function(event) {
      if ($(this).parents('tr').hasClass('open')) {
        $(this).collapseExpander({
          favorite: true
        });
      } else {
        $(this).expandExpander({
          favorite: true
        });
      }
      return $('table').redrawTableStrip();
    };
    $.fn.collapseExpander = function(options) {
      var $tr, defaults, fav, projectId, selector, settings;

      defaults = {
        favorite: false,
        bubbling: false
      };
      settings = $.extend({}, defaults, options);
      $tr = this.parents('tr');
      $tr.removeClass('open').addClass('closed');
      if ($tr.attr('id')) {
        projectId = $tr.attr('id').match(/[\d]{4}/)[0];
        fav = settings.favorite ? ".fav" : "";
        if (settings.bubbling) {
          selector = "tr.open.parent." + projectId;
          $("" + selector + fav + " span.expander").each(function() {
            return $(this).collapseExpander(options);
          });
        }
        $("tr.child." + projectId + fav).hide();
        return $("tr.parent." + projectId + fav).hide();
      }
    };
    $.fn.expandExpander = function(options) {
      var $tr, defaults, fav, parentFirstSubLevelProject, parentLevel, projectId, settings;

      defaults = {
        favorite: false,
        bubbling: false
      };
      settings = $.extend({}, defaults, options);
      $tr = this.parents('tr');
      $tr.removeClass('closed').addClass('open');
      if ($tr.attr('id')) {
        projectId = $tr.attr('id').match(/[\d]{4}/);
        fav = settings.favorite ? ".fav" : "";
        parentLevel = $tr.level();
        if (settings.bubbling) {
          $("tr.closed.parent." + projectId + fav + " span.expander").each(function() {
            return $(this).expandExpander(options);
          });
          return $("tr.parent." + projectId + fav).show();
        } else {
          parentFirstSubLevelProject = $.grep($("tr." + projectId + fav), function(el, index) {
            return $(el).level() === parentLevel + 1;
          });
          return $.each(parentFirstSubLevelProject, function(index, el) {
            return $(el).show();
          });
        }
      }
    };
    $('tbody tr form').on('ajax:success', function(evt, data, status, xhr) {
      var $parentProjectTr, $parentTr, $submitType, attr, level, projectId;

      $parentTr = $(this).parents('tr');
      $submitType = $(this).find('input[name="_method"]');
      if ($parentTr.hasClass('fav')) {
        if ($('#only-favorite-projects').hasClass('fav')) {
          $parentTr.hide();
          $parentProjectTr = $parentTr.parentProjectTr();
          if ($parentProjectTr != null) {
            projectId = $parentProjectTr.projectId();
            if (!($("tr." + projectId + ":visible").exists())) {
              $parentProjectTr.find('span.expander').off('clickFavorite');
            }
          }
        }
        $parentTr.removeClass('fav').addClass('unfav');
        $(this).find('input[type="submit"]').removeClass('fav').addClass('unfav');
        if ($submitType != null) {
          $submitType.attr('value', 'post');
        }
        if ($(this).parents("tr").hasClass('parent')) {
          attr = $(this).parents("tr").attr("class").match(/[\d]{4}/g);
          level = attr != null ? attr.length : 0;
          return $(this).parents("tr").tagChildren(level);
        }
      } else if ($parentTr.hasClass('unfav')) {
        $parentTr.removeClass('unfav').addClass('fav');
        if (!$submitType.exists()) {
          $submitType = $('<input>').attr('name', '_method').attr('type', 'hidden');
          $(this).find('div').prepend($submitType);
        }
        $submitType.attr('value', 'delete');
        $(this).find('input[type="submit"]').removeClass('unfav').addClass('fav');
        return $(this).tagParent();
      }
    }).bind('ajax:failure', function(evt, data, status, xhr) {
      return console.log("Something went horribly wrong. And it's all Charles' faults");
    });
    $.fn.level = function() {
      var attr, level;

      attr = this.attr("class").match(/[\d]{4}/g);
      return level = attr != null ? attr.length : 0;
    };
    $.fn.fav = function() {
      return this.removeClass('unfav').addClass('fav');
    };
    $.fn.unfav = function() {
      return this.removeClass('fav').addClass('unfav');
    };
    $.fn.isFav = function() {
      return this.hasClass('fav');
    };
    $.fn.isUnfav = function() {
      return this.hasClass('unfav');
    };
    $.fn.isParent = function() {
      if (this.hasClass('parent')) {
        return true;
      }
      if (this.parents('tr').hasClass('parent')) {
        return true;
      }
      return false;
    };
    $.fn.parentProjectTr = function() {
      var closestParentId, parentIds;

      parentIds = this.attr('class').match(/[\d]{4}/g);
      if (parentIds == null) {
        return void 0;
      }
      closestParentId = parentIds.reverse()[0];
      return $("tr#" + closestParentId + "span");
    };
    $.fn.projectId = function() {
      return this.attr('id').match(/[\d]{4}/)[0];
    };
    $.fn.tagChildren = function(level) {
      var els, projectId;

      projectId = this.attr('id').match(/[\d]{4}/)[0];
      els = $.grep($("tr.fav." + projectId), function(el) {
        var klazz;

        klazz = $(el).attr("class").match(/[\d]{4}/g);
        return (klazz != null) && klazz.length === (level + 1);
      });
      return $.each(els, function(index, el) {
        if ($(this).isFav()) {
          return $(el).find('form').submit();
        }
      });
    };
    $.fn.tagParent = function() {
      var $el, closestUnfavParents, klazz, parents;

      $el = this;
      klazz = $el.parents('tr').attr('class');
      parents = klazz.match(/[\d]{4}/g);
      if (parents) {
        closestUnfavParents = $.grep(parents.reverse(), function(parentId, index) {
          $el = $("tr.unfav#" + parentId + "span");
          return $el.exists();
        });
        if (closestUnfavParents.length > 0) {
          return $("tr.unfav#" + closestUnfavParents[0] + "span").find('form').submit();
        }
      }
    };
    $.fn.exists = function() {
      return this.length !== 0;
    };
    $('.project-custom-label-filter').change(function(e) {
      $(this).find('input[type=checkbox]').each(function() {
        var $td, classId;

        classId = $(this).data('field');
        $td = $("#projects-list .custom-field-" + classId);
        if ($(this).is(':checked')) {
          return $td.css("display", "");
        } else {
          return $td.css("display", "none");
        }
      });
      return $(this).submit();
    });
    $('#collapse-expand-all-projects').on('click', function(e) {
      var $anchor;

      e.preventDefault();
      $anchor = $(this);
      if ($anchor.hasClass('expanded')) {
        $anchor.addClass('collapsed').removeClass('expanded');
        $('tr.parent.open span.expander').each(function() {
          return $(this).collapseExpander();
        });
        $anchor.html("Expand all");
      } else if ($anchor.hasClass('collapsed')) {
        $anchor.addClass('expanded').removeClass('collapsed');
        $('tr.parent.closed span.expander').each(function() {
          return $(this).expandExpander();
        });
        $anchor.html("Collapse all");
      }
      return $('table').redrawTableStrip();
    });
    $('#only-favorite-projects').on('click', function(e) {
      var $anchor;

      e.preventDefault();
      $anchor = $(this);
      if ($anchor.hasClass('all')) {
        $('span.expander').off('clickRegular');
        $('span.expander').on('clickFavorite', expandFavorite);
        $anchor.removeClass('all').addClass('fav');
        $anchor.html("Show all projects");
        $('#collapse-expand-all-projects').hide();
        $('#projects-list tbody tr').each(function() {
          var projectId;

          if ($(this).hasClass('fav')) {
            $(this).show();
          } else {
            $(this).hide();
          }
          if ($(this).hasClass('parent')) {
            $(this).addClass('open').removeClass('closed');
            projectId = $(this).attr('id').match(/[\d]{4}/);
            if (!$("tr.fav." + projectId).exists()) {
              return $(this).find('span.expander').off('clickFavorite');
            }
          }
        });
      } else if ($anchor.hasClass('fav')) {
        $('span.expander').off('clickFavorite');
        $('span.expander').on('clickRegular', expandRegular);
        $anchor.removeClass('fav').addClass('all');
        $anchor.html("Only favorites");
        $('#collapse-expand-all-projects').show();
        $('tbody tr').each(function() {
          $(this).show();
          if ($(this).hasClass('parent')) {
            return $(this).addClass('open').removeClass('closed');
          }
        });
        $('#collapse-expand-all-projects').html("Collapse all");
        $('#collapse-expand-all-projects').removeClass('collapsed').addClass('expanded');
      }
      return $('table').redrawTableStrip();
    });
    $.fn.redrawTableStrip = function() {
      var alt;

      alt = 1;
      return this.find('tbody tr:visible').each(function() {
        var klass;

        $(this).removeClass('even odd');
        klass = ((alt++) % 2) === 0 ? "even" : "odd";
        return $(this).addClass(klass);
      });
    };
    $('#only-favorite-projects').trigger('click');
    return $('.project-custom-label-filter').trigger('change');
  });

}).call(this);
