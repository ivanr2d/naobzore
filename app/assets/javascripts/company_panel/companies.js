$(function() {
  var schedule = $('.days').data('schedule');
  var index;
  
  $('.days .day').click(function() {
    index = $(this).data('index');
    var s = schedule[index];
		if (typeof s.bf == 'undefined') s.bf = '';
		if (typeof s.bt == 'undefined') s.bt = '';
    $('.popup .day-name .title').text($(this).find('.title').text());
    var classes = ['from-hour', 'from-minute', 'to-hour', 'to-minute', 'break-from-hour', 'break-from-minute', 'break-to-hour', 'break-to-minute'];
    if (s.w) {
      $('.popup .weekend').attr('checked', 'checked');
      for (var i = 0; i < classes.length; i++) {
        $('.popup .' + classes[i]).val('').prev().text('');
      }
      $('.popup .break').removeAttr('checked').attr('disabled','disabled');;
			$('.popup p:has(.break), .popup .group, .popup .select').addClass('disabled');
    } else {
      $('.popup .weekend').removeAttr('checked');
			$('.popup .break').removeAttr('disabled');;
			$('.popup p:has(.break), .popup .group, .popup .select').removeClass('disabled');
      // TODO refactoring
      $('.popup .from-hour').val(s.f.split(':')[0]).prev().text(s.f.split(':')[0]);
      $('.popup .from-minute').val(s.f.split(':')[1]).prev().text(s.f.split(':')[1]);
      $('.popup .to-hour').val(s.t.split(':')[0]).prev().text(s.t.split(':')[0]);
      $('.popup .to-minute').val(s.t.split(':')[1]).prev().text(s.t.split(':')[1]);
      $('.popup .break-from-hour').val(s.bf.split(':')[0]).prev().text(s.bf.split(':')[0]);
      $('.popup .break-from-minute').val(s.bf.split(':')[1]).prev().text(s.bf.split(':')[1]);
      $('.popup .break-to-hour').val(s.bt.split(':')[0]).prev().text(s.bt.split(':')[0]);
      $('.popup .break-to-minute').val(s.bf.split(':')[1]).prev().text(s.bt.split(':')[1]);
      if (s.bf) {
        $('.popup .break').attr('checked', 'checked');
				$('.popup .break').closest('p').next('.group').removeClass('disabled');
      } else {
        $('.popup .break').removeAttr('checked');
				$('.popup .break').closest('p').next('.group').addClass('disabled');
      }
    }
  });

  $('.popup[data-type=timetable] .choice').live('click', function() {
    var day_schedule;
    if ($('.popup .weekend').attr('checked')) {
      day_schedule = {w: true};
    } else {
      var day_schedule = {
        f: $('.popup .from-hour').val() + ':' + $('.popup .from-minute').val(),
        t: $('.popup .to-hour').val() + ':' + $('.popup .to-minute').val()
      };
      if ($('.popup .break').attr('checked')) {
        day_schedule.bf = $('.popup .break-from-hour').val() + ':' + $('.popup .break-from-minute').val();
        day_schedule.bt = $('.popup .break-to-hour').val() + ':' + $('.popup .break-to-minute').val();
      }
    }
    schedule[index] = day_schedule;
    
    $('form.edit_company #company_schedule').val(JSON.stringify(schedule));
    $('form.edit_company').submit();

    var day_block = $('.days .day[data-index=' + index + ']');
    if (day_schedule.w) {
      day_block.find('.work').html('').prev('.key').html('Выходной').addClass('weekend');
      day_block.find('.break').html('&nbsp;').prev('.key').html('');
    } else {
      day_block.find('.work').text('с ' + day_schedule.f + ' до ' + day_schedule.t).prev('.key').text('Время работы').removeClass('weekend');
      if (day_schedule.bf) {
        day_block.find('.break').text('с ' + day_schedule.bf + ' до ' + day_schedule.bt).prev('.key').text('Перерыв');
      } else {
        day_block.find('.break').html('&nbsp;').prev('.key').html('&nbsp;');
      }
    }
    
    $('.popup[data-type=timetable] .close').click();
  });

  $('.popup[data-type=timetable] .weekend').live('change', function() {
    if ($(this).attr('checked')) {
      $('.popup .from-hour').val('').prev().text('');
      $('.popup .from-minute').val('').prev().text('');
      $('.popup .to-hour').val('').prev().text('');
      $('.popup .to-minute').val('').prev().text('');
      $('.popup .break').removeAttr('checked').attr('disabled','disabled');
			$('.popup p:has(.break), .popup .group, .popup .select').addClass('disabled');
    } else {
      $('.popup .from-hour').val('10').prev().text('10');
      $('.popup .from-minute').val('00').prev().text('00');
      $('.popup .to-hour').val('19').prev().text('19');
      $('.popup .to-minute').val('00').prev().text('00');
      $('.popup .break').attr('checked', 'checked').removeAttr('disabled','disabled');
			$('.popup p:has(.break), .popup .group, .popup .select').removeClass('disabled');
			$('.jquery-selectbox-list').hide();
    }
    $('.popup .break').change();
  });
  
  $('.popup[data-type=timetable] .break').live('change', function() {
    if ($(this).attr('checked')) {
      $('.popup .break-from-hour').val('13').prev().text('13');
      $('.popup .break-from-minute').val('00').prev().text('00');
      $('.popup .break-to-hour').val('14').prev().text('14');
      $('.popup .break-to-minute').val('00').prev().text('00');
			$(this).closest('p').next('.group').removeClass('disabled');
			$('.jquery-selectbox-list').hide();
    } else {
      $('.popup .break-from-hour').val('').prev().text('');
      $('.popup .break-from-minute').val('').prev().text('');
      $('.popup .break-to-hour').val('').prev().text('');
      $('.popup .break-to-minute').val('').prev().text('');
			$(this).closest('p').next('.group').addClass('disabled');
    }
  });

  $('#company_settlement_account').mask("999-99-999-9-9999-9999999");
  $('#company_post_index').mask("999-999");
  $('#company_creation_year').mask("9999");
  $('#company_bik').mask("999999999",{placeholder:" "});
  $('#company_kpp').mask("999999999",{placeholder:" "});
	$('#company_ogrn').mask("9999999999999",{placeholder:" "});

	$('#company_inn').mask('9999999999',{placeholder:" "})
	$('#company_inn').keyup(function(obj){
		var val = $(this).val().match(/\d+/i);
		var is_digit = ((obj.which >= 96) && (obj.which <= 105) || (obj.which >= 48) && (obj.which <= 57));
		if (!is_digit && !(obj.which == 8) && !(obj.which == 13) && !(obj.which == 27)) return;
		if (val.length) {
			if (val[0].length == 10 && is_digit) {
				$('#company_inn').unmask();
			}
		}
	})
	
	$('#company_inn').blur(function(){
		var val = $(this).val().match(/\d+/i);
		if (val[0].length == 11) $('#company_inn').mask('9999999999',{placeholder:" "});
	})

  $('#company_bank_cor_account').mask('99999-999-9-9999-9999999');
});
