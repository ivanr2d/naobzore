$(function() {
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
      $.getJSON('/company_panel/users/search.json', { q: request.term }, function(data) {
        if (data) {
          $('.autocomplite').removeClass('hidden');
        }
        response($.map(data, function(user) {
          var search_item = $('.search-item.hidden').clone();
          search_item.find('.fio').text(user.fio);
          if (user.birthday) { search_item.find('.birthday').text(user.birthday) };
          if (user.id) {$("#user_id").val(user.id)};
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
      if (ui.item.main_photo) { $('.found-employee .photo img').attr('src', ui.item.main_photo) };
      if (ui.item.f_name) { $('.found-employee .top .data p:eq(0)').text(ui.item.f_name) };
      if (ui.item.m_name) { $('.found-employee .top .data p:eq(1)').text(ui.item.m_name) };
      if (ui.item.l_name) { $('.found-employee .top .data p:eq(2)').text(ui.item.l_name) };
      if (ui.item.photo) { $('.found-employee .bottom .phone').text(ui.item.phone); $('.found-employee .bottom .phone-inp').val(ui.item.phone) };
      if (ui.item.email) { $('.found-employee .bottom .email').text(ui.item.email); $('.found-employee .bottom .email-inp').val(ui.item.email) }
      $('.found-employee #company_user_user_id').val(ui.item.id);
      $('.notfound-employee').addClass('hidden');
      $('.found-employee').removeClass('hidden');
    } 
  });

  $('.popup :button.cancel').live('click', function() {
    $('.popup[data-type="employee"] a.close').click();
  });

  $('.notfound-employee .register').live('click', function() {
    $('.search').addClass('hidden');
    $('.register-employee').removeClass('hidden');
  });

  $('.register-employee .back').live('click', function() {
    $('.register-employee').addClass('hidden');
    $('.search').removeClass('hidden');
  });

  $('#register_employee').on('submit', function() {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var email = $(this).find('[name*=email]').val();
    if (!re.test(email)) {
      alert('Некорректный Email');
      return false;
    } else {
      var res;
      $.get('/company_panel/companies_users/user_by_email', {email: email}, function(data) {
        if (data.id) {
          alert('Такой пользователь уже зарегистирован');
          res = false;
        } else {
          $('.popup[data-type="employee"] a.close').click();
          res = true;
        }
      });
      return res;
    }
  });
  
	$('.change-data', '.found-employee').click(function(e){
		$(this).siblings('.phone-inp, .email-inp, .phone, .email').toggleClass('hidden');
		if ($(this).text() == 'Изменить')
			$(this).text('Сохранить');
		else {
			type = $(this).siblings('span').attr('class');
               data = $(this).siblings(':text').val();
               $.ajax({
                   type: "PUT",
                   url: "/company_panel/companies_users/user_phone_email",
                   contentType: "application/json",
                   data: JSON.stringify({"data": data, "type": type, "id": $('#user_id').val()})
               });
			$(this).siblings('.phone, .email').text(data);
			$(this).text('Изменить');
		}
		e.preventDefault();
	});
});
