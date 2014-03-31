$(function(){
  $('#photo_file').change(function(){
    $(this).parents('form').submit();
  });

  /* select */
	if($('.mass-action').length > 0) $('.mass-action').selectbox({animationSpeed: 50}).bind('change', function(){
    var ids = [];
    $('.row-checkbox:checked').each(function(){
      ids[ids.length] = $(this).parents('tr').data('entity_id')
    });
    if (ids.length == 0){
      alert('Фотографии не выбраны');
      return false;
    }
    switch ($(this).val()*1) {
      case 3:
        if (confirm('Удалить выбранные фотографии?')) {
          $.post('/company_panel/photos/mass_destroy', {ids: ids}, function() { location.reload() });
        }
        break;
    }
  });
  
  function autocomplete_select(label, value){
    value = value || label;
    var td = $('a.points.caller').parents('td');
    td.find('.left').html(label);
    td.find('input[type="hidden"]').val(value);
    $('.popup-input').addClass('hidden');
    $('input.autocomplete').val('');
    var form = td.parent().find('form.edit_entity');
    var params = getFormParams(form);
    params[td.find('input[type="hidden"]').attr('name')] = value;
    params['photo[entity_type]'] = entity_type;
    $.post(form.attr('action'), params);
  }

  var entity_type = (document.location.search.match(/entity_type=(\w+)&?/) || [])[1] || 'Good';
  var parent_table = entity_type.toLowerCase() + 's';
  var input_autocomplete = $('input.autocomplete').autocomplete({
    appendTo: '.autocomplite .inner:visible',
    autoFocus: true,
    minLength: 3,
    messages: {
      noResults: '',
      results: function() {}
    },
    source: '/company_panel/' + parent_table + '/search.json',
    select: function(event, ui){
      autocomplete_select(ui.item.label, ui.item.value);
    }
  });

  $('.autocomplite .actions .send').click(function(){
    autocomplete_select($('input.autocomplete').val());
  });

  $('.replace-photo-file').change(function(){
    $(this).parents('form').submit();
  });

  $('.replace-photo-link').click(function(){
    $(this).parent().find('.replace-photo-file').click();
  });
});
