$(function(){
  $(':checkbox.notifications').change(function(){
    var res = [];
    $('.notifications:checked').each(function(){
      res[res.length] = $(this).val();
    });
    res = res.join(',');
    var form = $(this).parents('tr').find('form');
    var params = getFormParams(form);
    params['entity[notifications]'] = res;
    $.post(form.attr('action'), params);
  });

  if($('.mass-action').length > 0) $('.mass-action').selectbox({animationSpeed: 50}).bind('change', function(){
    var ids = [];
    $('.row-checkbox:not(.notifications):checked').each(function(){
      ids[ids.length] = $(this).parents('tr').data('entity_id')
    });
    if (ids.length == 0){
      alert('Акции не выбраны');
      return false;
    }
    switch ($(this).val()*1) {
      case 1:
        if (confirm('Опубликовать выбранные акции?')) {
          $.post('/company_panel/campaigns/mass_publish', {ids: ids}, function() { location.reload() });
        }
        break;
      case 2:
        if (confirm('Снять с публикации выбранные акции?')) {
          $.post('/company_panel/campaigns/mass_unpublish', {ids: ids}, function() { location.reload() });
        }
        break;
      case 3:
        if (confirm('Удалить выбранные акции?')) {
          $.post('/company_panel/campaigns/mass_destroy', {ids: ids}, function() { location.reload() });
        }
        break;
    }
  });
});
