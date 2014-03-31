$(function() {
  $('a.edit-subdomain').click(function() {
    $('.edited-subdomain').addClass('hidden');
    $('.editable-subdomain').removeClass('hidden');
  });

  function hideEditable() {
    $('.editable-subdomain').addClass('hidden');
    $('.edited-subdomain').removeClass('hidden');
  }

  $('.editable-subdomain .cancel').click(function() {
    hideEditable();
  });

  $('form.edit_site').on('ajax:complete', function(event, data) {
    var data = JSON.parse(data.responseText);
    if (data.success) {
      $('#current_site_subdomen').text($('#site_subdomen').val());
      hideEditable();
    } else {
      alert(data.errors.join("\n"));
    }
  });


  // редактирование списка поддоменов
  $('.static .edit').live('click', function() {
    var domen = $(this).parents('.domen');
    domen.find('.dynamic .value').val(domen.find('.static .value').text());
    domen.find('.static').addClass('hidden');
    domen.find('.dynamic').removeClass('hidden');
  });
  function hideDynamic(domen) {
    domen.find('.dynamic').addClass('hidden');
    domen.find('.static').removeClass('hidden');
  }
  $('.dynamic .ok').live('click', function() {
    var domen = $(this).parents('.domen');
    var value = $(this).siblings('[type=text]').val();
    // XXX вынести на сервер в валидацию
    if (!value) {
      alert('Поддомен не может быть пуст');
      return false;
    }
    if (!value.match(/^(([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/)) {
      alert('Поддомен имеет неверное значение');
      return false;
    }
    var counter = 0;
    $('.domens .domen:visible').each(function() {
      if ($(this).find('.value').text() == value) {
        counter += 1;
      }
    });
    if (counter > 1) {
      alert('Поддомен существует');
      return false;
    }
    domen.find('.value').text(value);
    hideDynamic(domen);
  });
  $('.dynamic .cancel').live('click', function() {
    hideDynamic($(this).parents('.domen'));
  });
  $('.domen .delete').live('click', function() {
    $(this).parents('.domen').remove();
  });
  $('#addDomen').click(function() {
    $('#newDomen').clone().removeClass('hidden').insertBefore($(this).parents('.domen'));
  });
});
