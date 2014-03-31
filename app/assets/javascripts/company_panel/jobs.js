$(function(){
  /* select */
	if($('.mass-action').length > 0) $('.mass-action').selectbox({animationSpeed: 50}).bind('change', function(){
    var ids = [];
    $('.row-checkbox:checked').each(function(){
      ids[ids.length] = $(this).parents('tr').data('entity_id')
    });
    if (ids.length == 0){
      alert('Вакансии не выбраны');
      return false;
    }
    switch ($(this).val()*1) {
      case 1:
        if (confirm('Опубликовать выбранные вакансии?')) {
          $.post('/company_panel/jobs/mass_publish', {ids: ids}, function() { location.reload() });
        }
        break;
      case 2:
        if (confirm('Снять с публикации выбранные вакансии?')) {
          $.post('/company_panel/jobs/mass_unpublish', {ids: ids}, function() { location.reload() });
        }
        break;
      case 3:
        if (confirm('Удалить выбранные вакансии?')) {
          $.post('/company_panel/jobs/mass_destroy', {ids: ids}, function() { location.reload() });
        }
        break;
    }
  });

  function favorite_contact_key() {
    return('company_' + $('#entity_company_id').val() + '_contact');
  }

  function load_favorite_contact(item) {
    if (item.email) $('#entity_contact_email').val(item.email);
    if (item.phone) {
      // TODO load all phones
      var main_phone = item.phone.split(';')[0];
      var matches = main_phone.match(/\((\d+)\)(\d+)/);
      $('.phones .phone:visible:gt(0)').remove();
      $('.phones .phone:visible input:eq(0)').val(matches[1]);
      $('.phones .phone:visible input:eq(1)').val(matches[2]);
      $('#autocomplete').val(item.fio);
    }
  }

  if ($.cookie(favorite_contact_key())) {
    try {
      var item = JSON.parse($.cookie(favorite_contact_key()));
    } catch(e) {
      $.cookie(favorite_contact_key(), null);
    }
    if (item) {
      load_favorite_contact(item);
    }
  }

  $('input#autocomplete').autocomplete({
    appendTo: '.autocomplite .inner',
    autoFocus: true,
    minLength: 3,
    messages: {
      noResults: function() {
        $('.autocomplite').addClass('hidden');
        $('.notfound-employee').removeClass('hidden');
        $('.found-employee').addClass('hidden');
      },
      results: function() {
        $('.autocomplite').removeClass('hidden');
      }
    },
    source: function(request, response) {
      $.getJSON('/company_panel/companies_users/search.json', { q: request.term }, function(data) {
        if (data) {
          $('.autocomplite').removeClass('hidden');
        }
        response($.map(data, function(user) {
          var search_item = $('.search-item.hidden').clone();
          search_item.find('.fio').text(user.fio);
          if (user.birthday) { search_item.find('.birthday').text(user.birthday) };
          if (user.companies.length) { search_item.find('.company').text(user.companies.join()) };
          user.label = search_item.html();
          user.value = user.fio;
          return user;
        }));
      });
    },
    open: function(event, ui) {
      $('.ui-autocomplete li').each(function() {
        $(this).find('a').html($(this).find('a').text());
      });
    },
    select: function(event, ui) {
      $('.autocomplite').addClass('hidden');
      load_favorite_contact(ui.item);
      $.cookie(favorite_contact_key(), JSON.stringify(ui.item));

      // if (ui.item.main_photo) { $('.found-employee .photo img').attr('src', ui.item.main_photo) };
      // if (ui.item.f_name) { $('.found-employee .top .data p:eq(0)').text(ui.item.f_name) };
      // if (ui.item.m_name) { $('.found-employee .top .data p:eq(1)').text(ui.item.m_name) };
      // if (ui.item.l_name) { $('.found-employee .top .data p:eq(2)').text(ui.item.l_name) };
      // if (ui.item.photo) { $('.found-employee .bottom .phone').text(ui.item.phone); $('.found-employee .bottom .phone-inp').val(ui.item.phone) };
      // if (ui.item.email) { $('.found-employee .bottom .email').text(ui.item.email); $('.found-employee .bottom .email-inp').val(ui.item.email) }
      // $('.found-employee #company_user_user_id').val(ui.item.id);
      // $('.notfound-employee').addClass('hidden');
      // $('.found-employee').removeClass('hidden');
    } 
  });
});
