not = 'undefined';

jQuery(document).ready(function($)
{
	W_WIDTH  = screen.width;
	W_HEIGHT = screen.height;

	

	/**
	 * Перетаскивание блоков
	 */
	if($(".column").length > 0)
	{
		//init plugin
		$(".column").sortable({
			connectWith: ".portlet-title",
			stop: function(event, ui) {
				reSortPortlets();
				// TODO rewrite with map
				var ids = [];
				$('.portlet').each(function(){
				ids[ids.length] = $(this).data('id');
				});
				$.post('/company_panel/widgets/save_order', {ids: ids});
			}
		});
		
		$(".column").disableSelection();


		function getBlockWidth(i) {
			if ($('.portlet').eq(i).hasClass('dual'))
				return 2
			else
				return 1;
		}
		
		function getBlocksLength() {
			return ($('.portlet').length);
		}
	
		function swapBlocks(i,k) {
			$('.portlet').eq(i).before($('.portlet').eq(k).remove());
		}
	
		function reSortPortlets() {
		var
			inRow = 3,
			i = 0,
			tSum = 0,
			bLen = getBlocksLength();
		
			while (i < bLen) {
				if (tSum + getBlockWidth(i) == inRow) {
					tSum = 0;
				}
				else if (tSum + getBlockWidth(i) > inRow) {
					var k = i+1;
					while (k < bLen) {
						if (tSum + getBlockWidth(k) == inRow) {
							swapBlocks(i,k);
							break;
						}
						k++;
					}
					tSum = 0;
				}
				else {
					tSum += getBlockWidth(i);
				}
				i++;
			}
		}
	}
    
  /**
   * Статистика
   */
  if ($('#stat_canvas').length) {
    function statShowTooltip(x, y, contents) {
      $('<div id="tooltip">' + contents + '</div>').css( {
        position: 'absolute',
        display: 'none',
        top: y + 16,
        left: x + 12,
        border: '1px solid #fdd',
        padding: '2px',
        'background-color': '#fee',
        opacity: 0.80
      }).appendTo("body").fadeIn(200);
    }

	  previousPoint = null;
    $('#stat_canvas').bind("plothover", function (event, pos, item) {
      if (item) {
          if (previousPoint != item.datapoint) {
          previousPoint = item.datapoint;
          $("#tooltip").remove();
          statShowTooltip(item.pageX, item.pageY, item.datapoint[1]);
          }
      } else {
        $("#tooltip").remove();
        previousPoint = null;
      }
    });

    var plot_options = {
      series: {
          lines: { show: true },
          points: { show: true }
      },
      grid: {
        hoverable: true
      },
      xaxis: {
        mode: "time",
        monthNames: $.datepicker.regional['ru'].monthNamesShort
      },
      yaxis: {
        min: 0
      },
      selection: {
        mode: "x"
      }
    };
    $.get('/company_panel/statistics.json' + document.location.search, function(data){
      var plot_data = []
      for (var good_id in data) {
        plot_data[plot_data.length] = {label: data[good_id].label, data: data[good_id].data};
      }
      $.plot($('#stat_canvas'), plot_data, plot_options);
			if ($('#view_statistics').length){
	      $('#stat_canvas').appendTo($('#view_statistics .content'));
			}
    });
  }
	
	/* input type file */
	$('.input-file input[type="file"]').live('change', function(){
		$('input[type="text"]', $(this).parent()).val($(this).val());
	});
	
    
    
	
    
	
	/* Редактирование телефонов при редактировании
	 * персональных данных
	 */
	$('#addPhone').live('click', function()
	{
		var phones = $(this).closest('.phones');
		var content = $('#newPhone').html();
		var newPhone = '<div class="phone">' + content + '</div>';
		phones.append(newPhone);
		return false;
	});
	$('.del-phone').live('click', function()
	{
		$(this).closest('.phone').remove();
		return false;
	});
	
    
    
	/* Редактирование факса при редактировании
	 * персональных данных
	 */
	$('#addFax').live('click', function()
	{
		var phones = $(this).closest('.phones');
		var content = $('#newFax').html();
		var newPhone = '<div class="phone">' + content + '</div>';
		phones.append(newPhone);
		return false;
	});
	$('.del-phone').live('click', function()
	{
		$(this).closest('.phone').remove();
		return false;
	});    

  /* Редактирование доменов при редактировании
	 * адреса сайта
	 */
	/*$('#addDomen').live('click', function()
	{
		var domens = $(this).closest('.domens');
		var content = $('#newDomen').html();
		var newDomen = '<div class="domen">' + content + '</div>';
		domens.append(newDomen);
		return false;
	});
	$('.del-domen').live('click', function()
	{
		$(this).closest('.domen').remove();
		return false;
	});*/
    
    
    /**
     _    _
    | |  | |
    | |  | |
    | |__| |
    |  __  |
    | |  | |
    | |  | |
    |_|  |_|
    
    **/

   
  /* Переключение вкладок в блоке с сущностями
	 * 
	 */  
  $('.tabs li a').live('click', function()
	{
    var parent = $(this).closest('.tabs').parent();
		var id = $(this).attr('data-id');
		
        // Выделение активной вкладки
		$('.tabs li a', parent).removeClass('active');
		$(this).addClass('active');
		
        // Переключение контентов вкладок
		$('.tab-content', parent).addClass('hidden');
		$('.tab-content[data-id="' + id + '"]', parent).removeClass('hidden');
		
		// замена образца баннера
		if ($(this).attr('data-type') == 'home') {
			$('.banner').addClass('home')
		}	else {
			$('.load-banner .banner').removeClass('home');	
		}
		
		return false;
	});
    
	
	
	/**
	 * Блок с категориями
	 * Служит для получения кода категории
	 */
	$('.categories .list-categories :checkbox').live('click', function(){
		$(this).siblings('a').click();
	})

	$('.categories .list-categories a').live('click', function()
	{
		var tab = $(this).closest('.tab-content').attr('data-id');
		var cid = $(this).parent().attr('data-cid');
		var pid = $(this).parent().attr('data-pid');
		
		var level  = $(this).closest('.list-categories').attr('data-level');
		var result = '';
		var height = 0;
        
        var popup = ($(this).closest('.popup').length > 0) ? $(this).closest('.popup') : false;
		
		// Получение объекта списка категорий
		var list = $('#listCategories li[data-pid="' + cid + '"]');
		
		// Получение HTML кода списка категорий
		if(list.length != 0)
		{
			for(var i = 0; i < list.length; i++)
			{
				result += list[i].outerHTML;
			}
            
            $('#codeCategory').html("-");
            
            //Если категории в попапе
            if(popup) $('input[name="result"]', popup).val(0);
		}
        else
        {
            // Отображение кода выбранной категории
            $('#codeCategory').html(cid);
            
            //Если категории в попапе
            if (popup) {
              $('input[name="result"]', popup).val(cid);
            } else {
              $('input[type="hidden"][name="entity[category_id]"]').val(cid);
            }
        }
		
		// Переключение
		switch(level)
		{
		
		// 2-й уровень
		case '1':
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html('');
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="3"]').html('');
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="2"]').html('0');
			
			$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 0}, 100);
			$('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'hidden');
			
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="2"]').html(result);
		break;
		
		// 3-й уровень
		case '2':
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html('');
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="3"]').html('');
			
			$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 0}, 100);
			 $('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'hidden');
			
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="3"]').html(result);
		break;
		
		// 4-й уровень
		case '3':
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html('');
			
			$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 0}, 100);
			
			if(list.length > 0) 
			{
				$('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'scroll');
				$('.tab-content[data-id="' + tab + '"]').parent().animate({scrollLeft: 1000}, 100);
			}
			else $('.tab-content[data-id="' + tab + '"]').parent().css('overflow-x', 'hidden');
			
			$('.tab-content[data-id="' + tab + '"] .list-categories[data-level="4"]').html(result);
		break;
		
		}
		
		// Вычисление максимальной высоты
		// Возможно улучшить перебрав каждый элемент списка узнав его высоту
		var max_items = 0;
		
		$('.tab-content[data-id="' + tab + '"] .list-categories').each(function()
		{
			if($('li', $(this)).length > max_items) max_items = $('li', $(this)).length;
		});
		
		// Установка максимальной высоты блокам
		$('.tab-content[data-id="' + tab + '"] .list-categories').height(max_items * 35);
		
		// Выделение активной категории на текущем уровне
		$('li a', $(this).closest('.list-categories')).removeClass('active').siblings(':checkbox').removeAttr('checked');
		$(this).addClass('active').siblings(':checkbox').attr('checked','checked');
		
		// Список выбранных категорий
		var selections = '';
		
		// Построение списка выбранных категорий
		$('.categories .tab-content[data-id="' + tab + '"] .active').each(function()
		{
			selections += $(this).html() + ' » ';
		});
		
		// Отображение списка выбранных категорий
		$('#selectCategories').html(selections.substring(0, selections.length - 2));
		
		return false;
	});
	
	
    
    
    
	
	/* Открытие блока с текстовым полем и автозаполнением
	 * (!) На странице списка фотографий
	 */
	$('a.points[data-type="popup-input"]').live('click', function()
	{
    $('a.points.caller').removeClass('caller');
    $(this).addClass('caller');
		var id = $(this).attr('data-item');
		var popup = $('.popup-input[data-item="' + id + '"]');
		
		$('.popup-input').addClass('hidden')
		popup.removeClass('hidden');
		
		return false;
	});
	// Закрытие вышеописанного блока
	$('.popup-input .cancel').live('click', function()
	{
		$(this).closest('.popup-input').addClass('hidden');
		return false;
	});
	
    
    
    
    
	
	/* Работа с полями на странице ПРАЙСА или еще гденить
	 * (!) Редактирование ячеек
	 */
	$('.dynamic-cell').live('click', function()
	{
        $('.dynamic-cell[data-type="text"], .dynamic-cell[data-type="select"]').each(function(){
            var temp = new DynamicCell($(this)).editOff();
        });
        var cell = new DynamicCell($(this)).editOn();
	});
    
  // Потеря фокуса
  $('.dynamic-cell input, .dynamic-cell select, .dynamic-cell radio').live('blur', function()
  {
      var temp = new DynamicCell($(this).closest('.dynamic-cell')).editOff();
  });
	
	// Реакция на Enter
	$('.dynamic-cell .input').live('keypress', function(e)
	{
		if(e.keyCode == 13){
      var temp = new DynamicCell($(this).closest('.dynamic-cell')).editOff();
      var form = $(this).parents('tr').find('form:first');
      var params = getFormParams(form);
      params[$(this).find('input').attr('name')] = $(this).find('input').val();
      $.post(form.attr('action'), params);
    }
	});
  $('.dynamic-cell .input select').live('change', function(){
    var form = $(this).parents('tr').find('form:first');
    var params = getFormParams(form);
    params[$(this).attr('name')] = $(this).val();
    $.post(form.attr('action'), params);
  });
  $('.live-checkbox').live('click', function() {
    var form = $(this).parents('tr').find('form:first');
    var params = getFormParams(form);
    params[$(this).attr('name')] = $(this).parents('.checkbox-group').find('.live-checkbox[name="' + $(this).attr('name') + '"]:checked').map(function() { return $(this).val() }).get();
    $.post(form.attr('action'), params);
  });
	
	
    
    
    
    
    
	/* Открытие попапа с категориями
	 * 
	 */

	function toggleAllParents(id) {
		function toggleRecursive(ids) {
			var categories = $('#listCategories [data-cid=' + ids[0] + '][data-pid!=0]');
			if (ids.length < 100 && categories.length) {
				categories.each(function() {
					toggleRecursive([$(this).data('pid')].concat(ids));
				})
			} else {
				$.each(ids, function(index, id) {
					$('.list-categories [data-cid=' + id + '] a').click();
				});
			}
		}
		toggleRecursive([id]);
	}
	if ($('#selectCategories[data-id]').length) {
		toggleAllParents($('#selectCategories').data('id'));
	}

    var popupCategories;
    
	$('a.points[data-type="popup-categories"]').live('click', function() {
		$('.categories .content .tab-content:first').removeClass('hidden');
		// NOTE Используется attr('data-id') а не data('id') потому что при смене атрибута data-id (выполняется при сохранении) data('id') не измеяется
		var category_id = $(this).attr('data-id');
		popupCategories = new Popup('categories', 0, $(this), {
			open: function() {
				toggleAllParents(category_id);
			}
		});
		popupCategories.open();
		return false;
	});
	// Закрытие вышеописанного блока
	$('.popup[data-type="categories"] .close').live('click', function()
	{
        popupCategories.close();
        popupCategories = undefined;
        
		return false;
	});
    // Нажатие на кнопку "Выбрать"
    $('.popup[data-type="categories"] .choice').live('click', function()
    {
        var result = popupCategories.getResult();
        var title = $('.list-categories li[data-cid=' + result + ']').text();
        
        if (result*1){
          popupCategories.getCaused().parent().next().html(title);
          popupCategories.getCaused().parent().next().next().val(result);

          var form = popupCategories.getCaused().parents('tr').find('form:first');
          var params = getFormParams(form);
          params['entity[category_id]'] = result;
          $.post(form.attr('action'), params);
		  if (popupCategories.getCaused().data('id')*1) {
			  popupCategories.getCaused().attr('data-id', result);
		  }
        }
        
        popupCategories.close();
        popupCategories = undefined;
        
        return false;
    });
    
    
    
    
    
    
    /**
     * Открытие поапа с характеристиками
     */
    var popupCharacteristics;
    // TODO refactoring
    $('.view-popup[data-type="characteristics"]').live('click', function()
    {
      $('.characteristics tr:not(.oblig, .head)').remove();
      var characteristics = $(this).attr('data-characteristics').split(',');
      for (var i = 0; i < characteristics.length; i++){
        var row = $('.characteristics tr.hidden').clone();
        row.removeClass('hidden').removeClass('oblig');
        row.find('input:first').attr('name', 'characteristics[][key]').val(characteristics[i].split(':')[0]);
        row.find('input:last').attr('name', 'characteristics[][value]').val(characteristics[i].split(':')[1]);
        $('.characteristics tr.hidden').before(row);
		refreshTableStrips();
      }
      popupCharacteristics = new Popup('characteristics', 0, $(this));
      popupCharacteristics.open();
	  $('.characteristics input[type="text"]').blur();
      return false;
    });
    //Добавление характеристики
    $('.add-characteristic').live('click', function(){
      var characteristic= $(this).parent().parent().siblings('.hidden').clone().removeClass('hidden').removeClass('oblig');
      characteristic.find('td:eq(0) input').attr('name', 'characteristics[][key]').val('Название');
      characteristic.find('td:eq(1) input').attr('name', 'characteristics[][value]').val('Значение');
      characteristic.insertBefore($(this).parent().parent());
	  refreshTableStrips();
    });
	// восстановление полос с учетом скрытых строк
	function refreshTableStrips() {
	  $('.characteristics .style-silver').find('tbody tr:not(.hidden, .oblig)').removeClass('lighter-row darker-row')
		.filter(':odd').addClass('lighter-row')
		.end().filter(':even').addClass('darker-row');
	};
	refreshTableStrips();
	// автодобавление новой строки для пустых таблиц характеристик
	if ($('.characteristics table').length && ($('.characteristics table tr:not(.oblig)').length <= 1)) {
		$('.add-characteristic').click();
	}

	// выделение рамкой полей ввода
	$('.characteristics input[type="text"]').live('blur', function() {
		var inp_val = $.trim($(this).val());
		if (inp_val == "") {
			var ind = $(this).closest('tr').find('td').index($(this).closest('td'));
			if (ind == 0)
				$(this).val('Название');
			else if (ind == 1)
				$(this).val('Значение');
		};
		if (inp_val == "" || inp_val == "Значение" || inp_val == "Название") $(this).addClass('bordered');
			else $(this).removeClass('bordered');
	})
	.live('focus', function(){
		var inp_val = $.trim($(this).val());
		if (inp_val == "Значение" || inp_val == "Название") 	$(this).val('');
	});
	
	  // Закрытие вышеописанного блока
    $('.popup[data-type="characteristics"] .close').live('click', function()
    {
      popupCharacteristics.close();
      popupCharacteristics = undefined;
      return false;
    });
    // Нажатие на кнопку "Выбрать"
    $('.popup[data-type="characteristics"] .choice').live('click', function()
    {
        var form = popupCharacteristics.getCaused().parents('tr').find('form:first');
        var params = getFormParams(form);
        params['characteristics'] = {' ':' '};
        var result = [];
        $(this).parents('.popup[data-type="characteristics"]').find('.characteristics table tr').each(function(){
          var name = $(this).find('td:eq(0) input[name^="characteristics"]').val();
          if (name){
            var value = $(this).find('td:eq(1) input[name^="characteristics"]').val();
            params['characteristics'][name] = value;
            result[result.length] = name + ':' + value;
          }
        });
        $.post(form.attr('action'), params);
        
        /******* Здесь действия при сохраниении характеристик **********/
        result = result.join(',');
        popupCharacteristics.getCaused().html(result || 'Добавить').attr('data-characteristics', result);
        
        popupCharacteristics.close();
        popupCharacteristics = undefined;
        
        return false;
    });
    
    
    
    
    
    
    /**
     * Открытие поапа с характеристиками
     */
    var popupDescription;
    
    $('.view-popup[data-type="description"]').live('click', function()
    {
        popupDescription = new Popup('description', $(this).attr('data-description'), $(this));
        popupDescription.open();
        
        return false;
    });
	// Закрытие вышеописанного блока
	$('.popup[data-type="description"] .close').live('click', function()
	{
        popupDescription.close();
        popupDescription = undefined;
        
		return false;
	});
    // Нажатие на кнопку "Выбрать"
    $('.popup[data-type="description"] .choice').live('click', function()
    {
        var result = popupDescription.getResult();
        var trunc_result = result.substring(0, 27) + '...';
       
        popupDescription.getCaused().html(trunc_result);
        popupDescription.getCaused().next().val(result);
        popupDescription.getCaused().attr('data-description', result);

        var form = popupDescription.getCaused().parents('tr').find('form:first');
        var params = getFormParams(form);
        params['entity[description]'] = result;
        $.post(form.attr('action'), params);
        
        popupDescription.close();
        popupDescription = undefined;
        
        return false;
    });
    
    
    
    
    
    
    
    
    
    /* Открытие попапа с выставлением времени
     *
     */
    
    var popupTimetable;
    
    $('.days .day').live('click', function(){
        
        popupTimetable = new Popup('timetable', 0, $(this));
        popupTimetable.open();
        
        $('.selectbox').selectbox({animationSpeed: 50}).bind('change', function(){
            // EVENT
        }); 
        
        popupTimetable.insertData = function()
        {
            //this._popup.html();
        }
        
        popupTimetable.insertData();
        
        return false;
    });
    // Закрытие вышеописанного блока
    $('.popup[data-type="timetable"] .close').live('click', function(){
          popupTimetable.close();
          popupTimetable = undefined;
          
      return false;
    });
    
    
    
    
   
   
    /* Открытие попапа с добавлением сотрудника
     *
     */
    
    var popupEmployee;
    
    $('.personal .new .top').live('click', function(){
        
        popupEmployee = new Popup('employee', 0, $(this));
        popupEmployee.open();
        
        return false;
    });
	// Закрытие вышеописанного блока
	$('.popup[data-type="employee"] .close').live('click', function()
	{
        popupEmployee.close();
        popupEmployee = undefined;
        
		return false;
	});

	/* Открытие попапа загрузки изображения
	*/
    var popupLoadImage;
    
    $('.view-popup[data-type="load-image"]').live('click', function()
    {
        popupLoadImage = new Popup('load-image', 0, $(this));
        popupLoadImage.open();
        
        return false;
    });

    $('a.load-popup[data-type="load-image"]').live('ajax:complete', function(event, data) {
      var popup = $('.popup[data-type="load-image"]');
      if (popup.length) {
        popup.replaceWith(data.responseText);
      } else {
        $('body').append(data.responseText);
      }
      popupLoadImage = new Popup('load-image', 0, $(this));
      popupLoadImage.open();
    });

		$('.link-simple:has(.load-popup)').live('click', function(){
			$('.load-popup').trigger('click');
		});
		
	// Закрытие вышеописанного блока
	$('.popup[data-type="load-image"] .close, .popup[data-type="load-image"] .save').live('click', function()
	{
        popupLoadImage.close();
        popupLoadImage = undefined;
        
		return false;
	});

	$('.popup[data-type="load-image"] .save').live('click', function()
	{
       // save actions
	});

	// выбор картинки
	/*$('.image-list-item').live('click', function(){
		$(this).closest('.image-list').find(':checkbox').removeAttr('checked');
		$(this).find(':checkbox').attr('checked', 'checked');
	})*/

	$('.mass-set-photos').live('click', function() {
		// Если находимся на странице создания/редактирования - добавляем input file и photos_ids hidden в форму
		if ($('#entity_form').length) {
			// XXX
			$(this).closest('.popup').find('.close').click();
			return false;
		}
	});

  /*$('.mass-set-photos').live('click', function() {
    // Для существующих записей
    if ($(this).data('entity_id')) {
      function render_data(data) {
        if (data.status == 200) {
          var entity = JSON.parse(JSON.parse(data.responseText).entity);
          console.debug(entity.image);
          $('[data-entity_id=' + entity.id + '] .preview img').attr('src', entity.image.thumb.url);
          $('[data-entity_id=' + entity.id + '] .title a').html(entity.image.url ? entity.image.url.split('/').pop() : 'no-image');
          $('.popup:visible .close').click();
        } else {
          $('.popup:visible .close').click();
          alert(data.message);
        }
      }
      var _this = $(this);
      // Сохраняем фотки из каталога
      $.post('/company_panel/' + _this.data('entity_table') + '/' + _this.data('entity_id') + '/mass_set_photos.json', {
        photo_ids: $('.image-list-item :checked').map(function() { return _this.data('photo_id') }).get().join(',')
      }, function(data) {
        // Сохраняем загруженную с компа картинку
        if ($('.input-file [name=result]').val()) {
          $.ajax('/company_panel/' + _this.data('entity_table') + '/' + _this.data('entity_id') + '.json', {
            type: 'POST',
            files: $('[name="entity[image]"]'),
            iframe: true,
            data: {'_method': 'PUT'},
            processData: false,
            dataType: 'json'
          }).complete(function(data) {
            render_data(data);
          });
        } else {
          render_data(data);
        }
      }, 'json');
    // Для новых записей
    } else {
      var form = $(this).parents('form');
      $('[name="photo_ids[]"]', form).remove();
      $('.image-list-item :checked').each(function() {
        $('<input type="hidden" name="photo_ids[]" value="' + _this.data('photo_id') + '" />').appendTo(form);
      });
      $('.popup:visible .close').click();
    }
  });*/

    if($('#construct').length > 0)
    {
        var construct = new Construct();
        construct.bindEvents();
    }
 
 
 
 
	/* Открытие попапа привязки изображения к товару/услуге/вакансии/акции
	*/
    var popupPhotoMatch;
    
    $('.view-popup[data-type="search-entity"]').live('click', function()
    {
        popupPhotoMatch = new Popup('search-entity', 0, $(this));
		$('.popup[data-type="search-entity"] .photo-match-entity').text($('.tab-content .photo-match-entity').text());
        popupPhotoMatch.open();
        $('#photo_entity_search').closest('.popup').find('.save').attr('data-id', $(this).data('item'));
        return false;
    });

	// Закрытие вышеописанного блока
	$('.popup[data-type="search-entity"] .close, .popup[data-type="search-entity"] .save').live('click', function()
	{
        popupPhotoMatch.close();
        popupPhotoMatch = undefined;
        
		return false;
	});

	$('.popup[data-type="search-entity"] .save').live('click', function()
	{
		var entity = $('#photo_entity_search_results tbody :checked:first');
		var tr = entity.closest('tr');
		if ($('#entity_form').length) {
			$('#entity_entity_id').val(entity.val());
			$('#entity_entity_type').val(tr.data('entity_type'));
			$('[type=text][data-type="search-entity"]').val(tr.data('name'));
		} else {
			var photo_id = $(this).attr('data-id');
			if (entity.length) {
				// XXX
	       		$.post('/company_panel/photos/' + photo_id, { photo: { entity_id: entity.val(), entity_type: tr.data('entity_type') }, _method: 'put' }, function() {
	       			$('tr[data-entity_id=' + photo_id + '] .ext-coll .left').text(tr.data('article') + '/' + tr.data('name'));
	       		});
	       	}
	    }
	});
	
	$('.popup[data-type="search-entity"] .style-silver :checkbox').live('click', function()
	{
      $('.popup[data-type="search-entity"] .style-silver :checkbox').not(this).removeAttr('checked');
	});
	
	if ($('#photo_entity_search').length) {
		$('#photo_entity_search').live_search({
			complete: function(data) {
				$('#photo_entity_search_results tbody').html('');
				for (var i in data) {
					$('#photo_entity_search_results tbody').append('<tr data-article="' + data[i].article + '" data-name="' + data[i].name + 
						'" data-entity_type="' + data[i].entity_type + '"><td><input type="checkbox" name="photo[entity_id]" value="' + data[i].id + 
						'" /></td><td>' + data[i].name + '</td><td><div class="entity-search-results-desc">' + data[i].description + '</div></td></tr>');
				}
			}
		})
	}
 
 
    /**
     * Замена стандартного чекбокса
     * Предварительный перебор чекбоксов
     */
    $('.replace-checkbox').each(function(){
        var checkbox = $('input[type="checkbox"]', $(this));
                
        if(!checkbox.attr("checked"))
        {
            checkbox.attr("checked", true); $(this).addClass('checked');
        }
        else
        {
            checkbox.attr("checked", false); $(this).removeClass('checked');
        }
    });
    //Клик по чекбоксу
    $('.replace-checkbox').live('click', function(){
        var checkbox = $('input[type="checkbox"]', $(this));
        
        if(!checkbox.attr("checked"))
        {
            checkbox.attr("checked", true); $(this).addClass('checked');
        }
        else
        {
            checkbox.attr("checked", false); $(this).removeClass('checked');
        }
    });
 
 
 
 
 
 
    /**
     * Селектозаменитель
     */
    $('.replace-select').each(function(){
        var value = $('input[type="hidden"]', $(this)).val();
        $('ul li', $(this)).removeClass('selected');
        $('ul li[data-value="' + value + '"]', $(this)).addClass('selected');
    });
    //Клик по оптиуму
    $('.replace-select ul li').live('click', function(){
        var select_container = $(this).closest('.replace-select');
        var value = $(this).attr('data-value');
        
        //Выклучаем все
        $('ul li', select_container).removeClass('selected');
        $(this).addClass('selected');
        
        //Меняем значение
        $('input[type="hidden"]', select_container).val(value);
    });
    
    if ($('.selectbox, .select-date select').length > 0) $('.selectbox, .select-date select').selectbox({animationSpeed: 50});
 
 
 
 
    /**
     * Установка всех чекбоксов в таблице
     */
    $('.checked-all').live('click', function(){
        
        var state = $(this).is(':checked');
        var checked = 0;
        
        $('.row-checkbox').each(function(){
            if(state)
            {
                $(this).attr('checked', 'checked');
                checked++;
            }
            else
                $(this).removeAttr('checked');
        });
        
        $('#checkedCount').text(checked);
    });
    /**
     * Подсчитывание чекнутых чекбоксов в таблице
     */
    $('.row-checkbox').live('click', function(){
    
        var checked = 0;
        
        $('.row-checkbox').each(function(){
            if($(this).is(':checked')) checked++;
        });
        
        $('#checkedCount').text(checked);
    });

	if ($('.live-filter').length) {
		$('.live-filter').live_filter({
			list: '.image-list',
			item: '.image-list-item',
			field: '.image-list-name'
		});
	}
	
	if ($('.live-search').lenght > 0) {
		$('.live-search').live_search({
			complete: function(data) {
				$('.live-search-count').html(data.length);
			}
		});
    }
    
	/* Открытие попапа групп
	*/
    var popupLoadGroup;
    
    $('.view-popup[data-type="edit-group"]').live('click', function()
    {
        popupLoadGroup = new Popup('edit-group', 0, $(this));
        // XXX
        $('#popup_group_form').find('[name="folder[number]"]').val($(this).closest('.folder').data('folder_number'));
        $('#popup_group_form').find('[name="folder[name]"]').val($(this).closest('.folder').data('folder_name'));
        $('#popup_group_form').find('[name="id"]').val($(this).closest('.folder').data('folder_id'));
        popupLoadGroup.open();
        
        return false;
    });

    $('a.load-popup[data-type="edit-group"]').live('ajax:complete', function(event, data) {
      var popup = $('.popup[data-type="edit-group"]');
      if (popup.length) {
        popup.replaceWith(data.responseText);
      } else {
        $('body').append(data.responseText);
      }
      popupLoadGroup = new Popup('edit-group', 0, $(this));
      popupLoadGroup.open();
    });

		
	// Закрытие вышеописанного блока
	$('.popup[data-type="edit-group"] .close,.popup[data-type="edit-group"] .cancel').live('click', function()
	{
        popupLoadGroup.close();
        popupLoadGroup = undefined;
        
		return false;
	});

	$('.popup[data-type="edit-group"] .save').live('click', function()
	{
		var action = $('#popup_group_form').attr('action');
    	var params = getFormParams($('#popup_group_form'));
    	if (params.id) {
    		action = action.replace('.json', '/' + params.id + '.json');
    		params['_method'] = 'put';
    	}
    	$.post(action, params, function(data) {
    		if (data.errors) {
    			alert(data.errors.join("\n"));
    		} else {
    			if (params.id) {
    				$('.table-group-list .folder[data-folder_id=' + params.id + ']').replaceWith(data.template);
    			} else {
    				$('.table-group-list').append(data.template);
    			}
    			popupLoadGroup.close();
    			popupLoadGroup = undefined;
    		}
    	}, 'json')
	});
	
    $('#folders_popup .folder').live('click', function() {
    	if ($('#entity_form').length) {
    		var parent = $('#entity_form');
    	} else {
    		var entity_translit = $(this).closest('#folders_popup').attr('data-entity_translit');
    		var parent = $('tr[data-entity_translit=' + entity_translit + ']');
    	}
		parent.find('#entity_folder_id').val($(this).data('folder_id'));
		parent.find('#entity_folder_name').val($(this).data('folder_name'));
		parent.find('#entity_folder_name').text($(this).data('folder_name'));
		console.debug('test1');
		if (!$('#entity_form').length) {
			$.post(location.pathname.replace(/\/$/, '') + '/' + entity_translit + '.json', { entity: { folder_id: $(this).data('folder_id') }, _method: 'put' });
		}
		$(this).closest('.autocomplite').hide();
	});

	$('.folder .link-del').live('ajax:complete', function() {
		$(this).closest('.folder').remove();
	})

	/*---------------------------------------------------------------------------------------------------------------------
	 | Вычисление параметров после загрузки страницы (например определить ширину и задать соответствующий стиль)
     | А также выполнение некоторых манипуляций html кодом
	 ---------------------------------------------------------------------------------------------------------------------*/
	if($('.scroll').length > 0)
	{
		height = W_HEIGHT - 600 - 50;
		$('.scroll').height(height);
	}

    
    /* Скрытие содержимого вкладок
     *
     */
    if($('.tab-content').length > 0)
    {
        $('.tab-content').each(function(index){
            if(index > 0) $(this).addClass('hidden');
        });
    }
    
    
    
 
		

    /**
     * Отображение, скрытие панели "Контакты"
     */
    $('#contactsPanel .panel').mouseenter(function(){
       $('#contactsPanel .panel').stop(true,true).delay(1500).animate({'margin-left': '13px'}, 70);
    });
    $('#contactsPanel .panel').mouseleave(function(){
        $('#contactsPanel .panel').stop(true,true).animate({'margin-left': '156px'}, 70);
	});
		
		// показать диалог с выбрнным пользователем
		$('.contact').click(function(){
			
			// действия по загрузке диалога с пользователем
			
		});

	$('.scrollable').jScrollPane();
    
    
    /* Таблицы */
   // if($('.table-akty').length > 0)  $('.table-akty').kegrid({width: 666, height: 'auto'});
	//  if($('.kegrid').length > 0) $('.kegrid').kegrid({width: 666, height: 'auto'});


	/* Ползунок переключения radio button  */

	if($('.slider-button').length > 0) {
		$('.slider-button-title.sb-action').click(function(){selSliderSale()});
		$('.slider-button-title.sb-sale').click(function(){selSliderAction()});
	
		$('.slider-button').click(function(){
			if ($('.slider-button').hasClass('on'))
				selSliderSale ()
			else
				selSliderAction ();
		});
	
		function selSliderSale () {
			$('.slider-button').removeClass('on').siblings('input[type="checkbox"]').attr('checked', 'checked');
			var title = $('.slider-button').closest('.form').find('h1.title');
			title.text(title.text().replace("скидки", "акции"));
			$('.img-for').text("акции");
			$('.row:has(.field-sale-size)').hide();
		}
	
		function selSliderAction () {
			$('.slider-button').addClass('on').siblings('input[type="checkbox"]').removeAttr('checked');
			var title = $('.slider-button').closest('.form').find('h1.title');
			title.text(title.text().replace("акции", "скидки"));
			$('.img-for').text("скидки");
			$('.row:has(.field-sale-size)').show();
		}
		
	}

	/* Добавление телефона/факса */

	$('.phone-add-link').click(function(e){
		$(this).siblings('.phone-add.pattern').clone().removeClass('pattern hidden').insertBefore($(this));
		e.preventDefault();
	});
	$('.phone-add .del-cross').live('click', function(e){
		$(this).closest('.phone-add').remove();
		e.preventDefault();
	});

	/* Читать полностью/свернуть */
	$('.read-more-link').click(function(e){
		$(this).closest('.body').find('.info-mini, .info-full').toggle();
		e.preventDefault();
	});
	
	/* Добавление акции/скидки */
	$('.select-spread').change(function(){
		$('.row:has(.select-spread-group, .field-spread-entity)').hide();
		$('.row[data-spread]').hide();
		$('.row[data-spread="' + $(this).val() + '"]').show();
		$('.row[data-spread]:visible .selectbox').selectbox();
	});
	
	/* Проверка занят ли поддомен сайта */
	$('.check-adress-link').click(function(e){
		// ajax request
		var resp = 1; // 0
		if (resp) {
			$('.check-adress-text').text('Адрес свободен').removeClass('error').addClass('success');
		} else {
			$('.check-adress-text').text('Такой адрес уже занят').removeClass('success').addClass('error');
		}
		e.preventDefault();
	});
	
	$('.field-for-group .btn-togglle-group, [data-role="select-group"],#entity_folder_name').click(function(e){
		var targ = $(this).closest('.field-for-group').find('.autocomplite').attr('data-entity_translit', $(this).closest('tr').data('entity_translit'))
		if ($(this).is('#entity_folder_name')) {
			targ.show();	
		} else {
			targ.toggle();
		}
		e.preventDefault();
	})
	
	// скрыть выбор групп в таблицах
		$(document).click(function(e){
			if (!$(e.target).closest('#folders_popup, #entity_folder_name, .btn-togglle-group').length && !$('#popup_group_form .popup').is(':visible')) {
				$('#folders_popup, .autocomplite[data-entity_translit], .top-bar-groups .autocomplite').hide(); 
			}
			
		})
	
	$(".kegrid-wrap").scroll(function(){
		$(".preview-dynamic").each(function(){
			$(this).css('left', $(this).siblings('.title').position().left +'px');
		})
	})
	
	$('#entity_folder_name').keydown(function(){return false;});
	
	/* Disabled selectbox */
	
	$('.selectbox.disabled').closest('.jquery-selectbox').addClass('disabled').unbind('click');
	
	/* виджеты меню */
	$('.extra ul li').mouseenter(function(){
		if ($(this).find('ul').length){
			$(this).addClass('active')
		}
	}).mouseleave(function(){
		$(this).removeClass('active')
	})
		
		// попап предложить работу 
    $('.suggest-job-link').live('click',function(){
			$(this).closest('.suggest-job').find('.suggest-job-popup').slideToggle('fast');
		})
		
		// стрелки прокрутки таблицы
		$('.kegrid-scroll-arr').each(function(){
			var table = $(this).closest('.kegrid-wrap-outer').find('.kegrid'),
					table_th_h = table.find('th:first').outerHeight();
				$(this).css({top: table_th_h + 'px', height: $(table).outerHeight() - table_th_h + 'px'})
				if (!$(this).height())	$(this).hide();
		});
		
		if (!NB) var NB = {};
		NB.kegrig_scroll_timer = 0;
		$('.kegrid-scroll-arr').mouseenter(function(){
			var container = $(this).siblings('.kegrid-wrap'),
					direct = $(this).is('.kegrid-scroll-arr-l') ? '-' : '+';
			NB.kegrig_scroll_timer = setInterval(function(){
				container.animate({scrollLeft: (direct+'=20')}, 100, 'linear')
			},100)			
		}).mouseleave(function(){
			if (NB.kegrig_scroll_timer) clearInterval(NB.kegrig_scroll_timer);
			$(this).siblings('.kegrid-wrap').stop(true, true);
		})

	


    /*----------------------------------------------------------------------------------------------------*
    | TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP TEMP |
    *-----------------------------------------------------------------------------------------------------*/
    
    $('#VIEW_POPUP').click(function()
    {
        var popupLoading = new Popup('loading');
        popupLoading.open();
        
        $('.popup[data-type="loading"] .info-slider').jCarouselLite({
	        btnNext: '.popup[data-type="loading"] .buttons .next',
	        btnPrev: '.popup[data-type="loading"] .buttons .prev',
	        visible: 1,
	        speed: 500,
            auto: 5000,
	        circular: false,
            afterEnd: function(item, index)
            {
                $('.curent-slide .num').html(index + 1);
            }
	    });
    });

  $('a.replace-by-video[data-url]').click(function() {
    $(this).replaceWith(embedVideo($(this).data('url'), $(this).data('width'), $(this).data('height')));
  });
});

function DynamicCell(cell)
{
    var limit = 12;

    this._title = $('.title', cell);
    this._input = $('.input', cell);
    
    this.editOn = function()
    {
        this._input.removeClass('hidden');
        this._title.addClass('hidden');
        $('input', this._input).focus();
    }
    
    this.editOff = function()
    {
        var value = $('input, select, radio', this._input).val();
        
        this._input.addClass('hidden');
        this._title.removeClass('hidden');
        
        this._title.html(this.filter(value));
    }
    
    this.filter = function(value)
    { 
        result = 0;
        
        if(value && value.length > limit)
            result = value.substring(0, limit) + '...';
        else
            result = value;
        
        return result;
    }
    
    return this;
}


/**
 * @param string type - Тип
 * @param mixed data - Данные попапу
 * @param JQuery object caused - Объект вызванный попап
 */
function Popup(type, data, caused, callbacks)
{
	this.callbacks = callbacks || {};
    this._popup = $('.popup[data-type="' + type + '"]');
    
    this._width = this._popup.outerWidth();
    this._height = this._popup.outerHeight();
    
    //Параметры по умолчанию
    this._caused = (typeof caused != "undefined") ? caused : false;
	this._type = (typeof type != "undefined") ? type : false;
    this._data = (typeof data != "undefined") ? data : false;
    
    this._result = $('*[name="result"]', this._popup);
    
    this.settingStyle = function()
    {
        this._popup.css({
            left  : '50%',
            top : '50%',
            marginLeft  : -(this._width / 2),
            marginTop : -(this._height / 2),
            zIndex : 100
        });
    }
    
    this.open = function()
    {
        if(!this._state) this._popup.removeClass('hidden');
        this.settingStyle();
        
        if(data)
        {
            this._result.val(data)
        }

		if (type == 'description') {
			if (CKEDITOR.instances.result) {
				CKEDITOR.instances.result.destroy();
			}
			CKEDITOR.replace(this._result.get(0));
		}
        
        this._state = true;

		if (callbacks && callbacks.open) {
			callbacks.open();
		}
    }
    
    this.close = function()
    {
        if(this._state) this._popup.addClass('hidden');
        this._state = false;
    }
    
    /**
     * Получение результата попапа
     */
    this.getResult = function()
    {
		if (this._type == 'description') {
			return CKEDITOR.instances.result.getData();
		} else {
			return this._result.val();
		}
    }
    
    /**
     * Получение объекта по которому вызвался попап
     */
    this.getCaused = function()
    {
        return this._caused;
    }
    
    return this;
}

function getFormParams(form) {
  var obj = {};
  $.each(form.serializeArray(), function(_, kv) {
    if (obj.hasOwnProperty(kv.name)) {
      obj[kv.name] = $.makeArray(obj[kv.name]);
      obj[kv.name].push(kv.value);
    } else {
      obj[kv.name] = kv.value;
    }
  });
  return obj;
}

function embedVideo(url, width, height) {
  width = width || 400;
  height = height || 300;
  return  '<video width="' + width + '" height="' + height + '" controls>' +
          '<source src="' + url + '" type="video/mp4">' +
          '<object data="' + url + '" width="' + width + '" height="' + height + '">' +
          '<embed src="' + url + '" width="' + width + '" height="' + height + '">' +
          '</object></video>'
}

/**
     * Открытие поапа с отправки сообщения
     */
    var popupDescription;
    
    $('.view-popup[data-type="send-message"], #support_service .blue-button').live('click', function(){
      if ($(this).data('to_id')){
        $('form#new_message').append('<input type="hidden" name="message[to_id]" value="' + $(this).data('to_id') + '" />');
      }
      if ($(this).data('action')) {
        $('form#new_message').attr('action', $(this).data('action'));
      }
      popupDescription = new Popup('send-message', $(this).text(), $(this));
      $('.popup[data-type="send-message"] .title').text($(this).data('title') || 'Сообщение компании');
      popupDescription.open();
      
      return false;
    });
	// Закрытие вышеописанного блока
	$('.popup[data-type="send-message"] .close').live('click', function(){
        popupDescription.close();
        popupDescription = undefined;
        
		return false;
	});
    // Нажатие на кнопку "Выбрать"
    $('.popup[data-type="send-message"] .send').live('click', function(){
        var result = popupDescription.getResult();
       
        
        
        return false;
    });

