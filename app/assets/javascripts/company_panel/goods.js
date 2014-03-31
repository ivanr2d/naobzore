$(function(){
  /* select */
	if($('.mass-action').length > 0) $('.mass-action').selectbox({animationSpeed: 50}).bind('change', function(){
    var ids = [];
    $('.row-checkbox:checked').each(function(){
      ids[ids.length] = $(this).parents('tr').data('entity_id')
    });
    if (ids.length == 0){
      alert('Товары не выбраны');
      return false;
    }
    switch ($(this).val()*1) {
      case 1:
        if (confirm('Опубликовать выбранные товары?')) {
          $.post('/company_panel/goods/mass_publish', {ids: ids}, function() { location.reload() });
        }
        break;
      case 2:
        if (confirm('Снять с публикации выбранные товары?')) {
          $.post('/company_panel/goods/mass_unpublish', {ids: ids}, function() { location.reload() });
        }
        break;
      case 3:
        if (confirm('Удалить выбранные товары?')) {
          $.post('/company_panel/goods/mass_destroy', {ids: ids}, function() { location.reload() });
        }
        break;
    }
  });
});
