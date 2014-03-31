$(function(){
  /* select */
	if($('.mass-action').length > 0) $('.mass-action').selectbox({animationSpeed: 50}).bind('change', function(){
    var ids = [];
    $('.row-checkbox:checked').each(function(){
      ids[ids.length] = $(this).parents('tr').data('entity_id')
    });
    if (ids.length == 0){
      alert('Резюме не выбраны');
      return false;
    }
    switch ($(this).val()) {
      case 'reject':
        if (confirm('Отказать по выбранным заявкам?')) {
          $.post('/company_panel/companies_resumes/mass_reject', {ids: ids}, function() { location.reload() });
        }
        break;
      case 'destroy':
        if (confirm('Удалить выбранные заявки?')) {
          $.post('/company_panel/companies_resumes/mass_destroy', {ids: ids, _method: 'DELETE'}, function() { location.reload() });
        }
        break;
    }
  });
});
