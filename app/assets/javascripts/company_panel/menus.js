$(function() {
  $("#menuPosition").sortable({
    start: function(event, ui) {
      ui.item.startPos = ui.item.index();
    },
    stop: function(event, ui) {
      var n1 = ui.item.startPos;
      var n2 = ui.item.index();
      var ids = [];
      $(this).find('li[data-menu_id]').each(function() {
        ids[ids.length] = $(this).data('menu_id');
      });
      $('#ids').val(ids.join(','));
      $(this).parents('form').submit();
    }
  });
});
