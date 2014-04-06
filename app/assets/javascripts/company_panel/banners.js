$(function(){
	
	if (!Date.prototype.getWeek) Date.prototype.getWeek = function() {
    var onejan = new Date(this.getFullYear(), 0, 1);
    return Math.ceil((((this - onejan) / 86400000) + onejan.getDay() + 1) / 7);
  }
	
  var months = $('.calendar-buttons:first').data('months').split(',');
  var month_names = $('.calendar-buttons:first').data('month_names').split(',');
  var month_index = 0;
	var week_num = (new Date()).getWeek();
	
	
	$('.calendar tr').each(function(){
		if (week_num - 1 > $(this).data('week')) {
			$(this).addClass('old-week');
		}
	})

  function setMonth(obj, month_index) {
    var tab = obj.parents('.tab-content');
    tab.find('.calendar[data-month!=' + months[month_index] + ']:not(.hidden)').addClass('hidden');
    tab.find('.calendar[data-month=' + months[month_index] + ']').removeClass('hidden');
    obj.siblings('.current').text(month_names[month_index]);
  }

  $('.calendar-buttons .prev').click(function(){
    if (months[month_index - 1]) {
      month_index--;
      setMonth($(this), month_index);
    }
  });

  $('.calendar-buttons .next').click(function(){
    if (months[month_index + 1]) {
      month_index++;
      setMonth($(this), month_index);
    }
  });

  var type = $('.tabs li a.active').data('type');
  $('.tabs li a').click(function() {
    type = $(this).data('type');
  });

  var weeks = {};
  $('.tabs li a').each(function() {
    weeks[$(this).data('type')] = [];
  });

  var flatten_weeks = [];
  $('.load-banner .calendar tr').click(function(){
    if ($(this).hasClass('selected')) {
      $('.load-banner .calendar tr[data-week=' + $(this).data('week') + '][data-type=' + type + ']').removeClass('selected');
      var index = weeks[type].indexOf($(this).data('week'));
      if (index > -1) {
        weeks[type].splice(index, 1);
      }
    } else if (!$(this).hasClass('busy') && (week_num - 1 <= $(this).data('week'))) {
				$('.load-banner .calendar tr[data-week=' + $(this).data('week') + '][data-type=' + type + ']').addClass('selected')
				var index = weeks[type].indexOf($(this).data('week'));
				if (index == -1) {
					weeks[type][weeks[type].length] = $(this).data('week');
			}
    }
    // заполняем период размещения
    flatten_weeks = [];
    var count_weeks = 0;
    for (var t in weeks) {
      for (var i = 0; i < weeks[t].length; i++) {
        count_weeks++;
        if (flatten_weeks.indexOf(weeks[t][i]) == -1) {
          flatten_weeks[flatten_weeks.length] = weeks[t][i];
        }
      }
    }
    $('.sum').text($('.sum').data('week_price') * count_weeks);
    flatten_weeks = flatten_weeks.sort();
    var periods = [];
    if (flatten_weeks.length > 0) {
      periods[0] = {};
      periods[0].start = $('.load-banner .calendar tr[data-week=' + flatten_weeks[0] + ']:first').data('week_start');
      periods[0].finish = $('.load-banner .calendar tr[data-week=' + flatten_weeks[0] + ']:first').data('week_finish');
      for (var i = 1; i < flatten_weeks.length; i++) {
        if (flatten_weeks[i] - flatten_weeks[i-1] > 1) {
          periods[periods.length] = {};
          periods[periods.length - 1].start = $('.load-banner .calendar tr[data-week=' + flatten_weeks[i] + ']:first').data('week_start');
        }
        periods[periods.length - 1].finish = $('.load-banner .calendar tr[data-week=' + flatten_weeks[i] + ']:first').data('week_finish');
      }
    } else {
      periods = [];
    }
    for (var i = 0; i < periods.length; i++) {
      periods[i] = 'c ' + periods[i].start + ' по ' + periods[i].finish;
    }
    $('.period').text(periods.join(', '));
  });

  $('.banner.home').click(function() {
    $('#new_banner [type=file]').click();
  });
	
	$('#new_banner [type=file]').change(function(){
		if (this.files && this.files[0]) {
			var reader = new FileReader();
			reader.onload = function (e) {
				$('.banner img').hide();
				$('.banner .img-loaded').attr('src', e.target.result).show();
				$('.banner-reload').show();
			}
			reader.readAsDataURL(this.files[0]);
		}
	});

  $('#new_banner').submit(function() {
    if (flatten_weeks.length == 0) {
      alert('Выберите срок размещения');
      return false;
    }

    if (!$('#banner_banner').val()) {
      alert('Загрузите баннер');
      return false;
    }

    if (!$('#banner_link').val()) {
      alert('Укажите ссылку');
      return false;
    }

    $('#weeks').val(JSON.stringify(weeks));
  });
});
