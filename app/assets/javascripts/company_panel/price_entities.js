$(function(){
  $(':checkbox.available').change(function(){
    var form = $(this).parents('tr').find('form:first');
    var params = getFormParams(form);
    params[$(this).attr('name')] = $(this).attr('checked') ? '1' : '0';
    $.post(form.attr('action'), params);
  });

  /* select */
	if($('.mass-action').length > 0) $('.mass-action').selectbox({animationSpeed: 50}).bind('change', function(){
    var ids = [];
    $('.row-checkbox:checked').each(function(){
      ids[ids.length] = $(this).parents('tr').data('entity_id')
    });
    if (ids.length == 0){
      alert('Не выбрано');
      return false;
    }
    switch ($(this).val()*1) {
      case 3:
        if (confirm('Удалить отмеченное?')) {
          $.post('/company_panel/price_entities/mass_destroy', {ids: ids}, function() { location.reload() });
        }
        break;
    }
  });

  $('.replace-photo-file').change(function(){
    $(this).parents('form').submit();
  });

  $('.replace-photo-link').click(function(){
    $(this).parent().find('.replace-photo-file').click();
  });

});
