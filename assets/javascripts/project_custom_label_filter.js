$(function() {
  $('#project-custom-label-filter').change(function() {
    $(this).find('input[type=checkbox]').each(function() {
      classId = $(this).data('field');
      $td = $("#projects-list .custom-field-" + classId);
      if (this.checked)
        $td.css("display", "");
      else
        $td.css("display", "none");
    });

    $(this).submit();
  });

  $('#project-custom-label-filter').trigger('change');
});