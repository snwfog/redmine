$(function() {
  $('#project-custom-label-filter').change(function() {
    $(this).find('option').each(function() {
      classId = $(this).attr('value');
      $td = $("#projects-list .custom-field-" + classId);
      if (this.selected)
        $td.css("display", "");
      else
        $td.css("display", "none");
    });

    $(this).submit();
  });

  $('#project-custom-label-filter').trigger('change');
});