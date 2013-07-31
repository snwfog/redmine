/* Function to allow the projects to show up as a tree */

//Event.observe(window, 'load', function () {
//  if ($('expand_all')) {
//    $('expand_all').observe('click', function () {
//      $$('table.list tr').each(function (e) {
//        e.addClassName('open');
//        e.removeClassName('hide');
//      });
//    });
//  }
//});

$(document).ready(function() {
  $('#collapse-expand-all-projects').click(function(event)
  {
    if (/\bCollapse\b/.exec($(this).html()))
    {
      toggle('open');
      $(this).html("Expand All");
    }
    else
    {
      toggle('closed');
      $(this).html("Collapse All");
    }

    event.preventDefault();
  });

  $('#only-favorite-projects').click(function(event)
  {
    if (/\bOnly Favorites\b/.exec($(this).html()))
    {
      filterFavoriteProjects();
      $(this).html("Show All Projects");
      $('#collapse-expand-all-projects').css({'display': 'none'});
      $('tr:not(.hide) span.expander').css({'display': 'none'});
    }
    else
    {
      $('tr:not(.hide) span.expander').css({'display': ''});
      $('#collapse-expand-all-projects').css({'display': ''});
      $(this).html("Only Favorites");
      unfilterFavoriteProjects();
      toggle('closed');
      $('#collapse-expand-all-projects').html("Collapse All");
    }

    event.preventDefault();
  });
});

function toggle(state)
{
  $('tr.' + state + '.parent span.expander').each(function() {
    if (this.hasOwnProperty('onclick'))
    {
      return this.onclick.call();
    }

  });
}

function filterFavoriteProjects()
{
  toggle('closed');

  $('#projects-list tbody tr').each(function()
  {
    var classProp = $(this).prop('class');
    if (/\bfav\b/.exec(classProp))
    {
      $(this).prop('class', classProp.replace(/hide/, ''));
    }
    else
    {
      if (!/\bhide\b/.exec(classProp))
      {
        $(this).prop('class', classProp + " hide");
      }
    }
  });

  redrawTableStrip();
}

function unfilterFavoriteProjects()
{
  $('#projects-list tbody tr.hide').each(function()
  {
    var classProp = $(this).prop('class');
    if (/\bhide\b/.exec(classProp))
    {
      $(this).prop('class', classProp.replace(/hide/, ''));
    }
  });

  toggle('open');
  redrawTableStrip();
}

function redrawTableStrip()
{
  var alt = 0;
  $('#projects-list tr:not(tr.hide)').each(function()
  {
    var classProp = $(this).prop('class');
    $(this).prop('class', classProp.replace(/(even|odd)/, ''));
    classProp = $(this).prop('class') + ((((alt++) % 2) == 0) ? " even" : " odd");
    console.log(classProp);
    $(this).prop('class', classProp);
  });
}

$.fn.redrawTableStrip = function() {
  var alt;
  alt = 1;
  return this.find('tbody tr:not(tr.hide)').each(function() {
    var classProp;
    classProp = $(this).prop('class');
    classProp = classProp.replace(/(even|odd)/, "");
    classProp += ((alt++) % 2) === 0 ? " even" : " odd";
    return $(this).prop('class', classProp);
  });
};


function showHide(EL, PM) {
  var els = document.getElementsByTagName('tr');
  var elsLen = els.length;
  var pattern = new RegExp("(^|\\s)" + EL + "(\\s|$)");
  var cpattern = new RegExp("span");
  var expand = new RegExp("open");
  var collapse = new RegExp("closed");
  var hide = new RegExp("hide");
  var spanid = PM;
  var classid = new RegExp("junk");
  var oddeventoggle = 0;
  for (i = 0; i < elsLen; i++) {

    if (cpattern.test(els[i].id)) {
      var tmpspanid = spanid;
      var tmpclassid = classid;
      spanid = els[i].id;
      classid = spanid;
      classid = classid.match(/(\w+)span/)[1];
      classid = new RegExp(classid);
      if (tmpclassid.test(els[i].className) && (tmpspanid.toString() != PM.toString())) {
        if (collapse.test(document.getElementById(tmpspanid).className)) {
          spanid = tmpspanid;
          classid = tmpclassid;
        }
      }
    }

    if (pattern.test(els[i].className)) {

      var cnames = els[i].className;

      cnames = cnames.replace(/hide/g, '');

      if (expand.test(document.getElementById(PM).className)) {
        cnames += ' hide';
      }
      else {
        /* classid test function is buggy and matches incorrect ids 5 matches 50. */
        if ((spanid.toString() != PM.toString()) &&
            (classid.test(els[i].className))) {
          if (collapse.test(document.getElementById(spanid).className)) {
            cnames += ' hide';
          }
        }
      }

      els[i].className = cnames;

    }

    if (!(hide.test(els[i].className))) {
      var cnames = els[i].className;
      cnames = cnames.replace(/odd/g, '');
      cnames = cnames.replace(/even/g, '');

      if (oddeventoggle == 0) {
        cnames += ' odd';
      }
      else {
        cnames += ' even';
      }

      oddeventoggle ^= 1;
      els[i].className = cnames;
    }
  }
  if (collapse.test(document.getElementById(PM).className)) {
    var cnames = document.getElementById(PM).className;
    cnames = cnames.replace(/closed/, 'open');
    document.getElementById(PM).className = cnames;
  }
  else {
    var cnames = document.getElementById(PM).className;
    cnames = cnames.replace(/open/, 'closed');
    document.getElementById(PM).className = cnames;
  }
}

