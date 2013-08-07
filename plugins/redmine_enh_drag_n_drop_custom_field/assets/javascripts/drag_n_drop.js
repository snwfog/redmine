// Generated by CoffeeScript 1.6.2
(function() {
  $(function() {
    var removeMouseOver;

    $('.list tbody').sortable({
      stop: function(event, ui) {
        var position, thisFieldId;

        $(this).parents('table').redrawTableStrip();
        thisFieldId = ui.item.data('field-id');
        position = $(this).sortable('toArray').indexOf("field_" + thisFieldId) + 1;
        return $.ajax({
          type: "PUT",
          url: "/custom_fields/" + thisFieldId,
          data: {
            insert_at: position
          }
        });
      },
      handle: "span.dnd-handle",
      cursor: "-webkit-grabbing"
    });
    $('span.dnd-handle').mouseenter(function(event) {
      var classProp;

      classProp = $(this).prop('class');
      return $(this).prop('class', classProp + " mouseover");
    });
    removeMouseOver = function(event) {
      var classProp;

      classProp = $(event.target).prop('class');
      return $(event.target).prop('class', classProp.replace(/\s+mouseover/, ''));
    };
    $('span.dnd-handle').mousedown(removeMouseOver);
    return $('span.dnd-handle').mouseleave(removeMouseOver);
  });

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

}).call(this);