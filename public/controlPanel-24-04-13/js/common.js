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
		$(".column").sortable({
			connectWith: ".portlet-title"
		});
		
		$(".column").disableSelection();
	}
	
    
    
    
    
    /* Таблицы */
    if($('.table-akty').length > 0)  $('.table-akty').kegrid({width: 660, height: 150});
	
    
    
	
	/* input type file */
	$('.input-file input[type="file"]').live('change', function(){
		$('input[type="text"]', $(this).parent()).val($(this).val());
	});
	
    
    
	
    
	/* select */
	if($('.selectbox').length > 0) $('.selectbox').selectbox({animationSpeed: 50}).bind('change', function(){
       	// EVENT
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
		
		return false;
	});
	
    
    
    
    
    
    
    
	
	
	/**
	 * Блок с категориями
	 * Служит для получения кода категории
	 */
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
            if(popup) $('input[name="result"]', popup).val(cid);
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
		$('li a', $(this).closest('.list-categories')).removeClass('active');
		$(this).addClass('active');
		
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
	$('.input').live('keypress', function(e)
	{
		if(e.keyCode == 13) var temp = new DynamicCell($(this).closest('.dynamic-cell')).editOff();
	});
	
	
    
    
    
    
    
	/* Открытие попапа с категориями
	 * 
	 */
    var popupCategories;
    
	$('a.points[data-type="popup-categories"]').live('click', function()
	{
        popupCategories = new Popup('categories', 0, $(this));
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
        var insert = popupCategories.getCaused().parent().next();
        
        popupCategories.getCaused().parent().next().html(result);
        popupCategories.getCaused().parent().next().next().val(result);
        
        popupCategories.close();
        popupCategories = undefined;
        
        return false;
    });
    
    
    
    
    
    
    /**
     * Открытие поапа с характеристиками
     */
    var popupCharacteristics;
    
    $('.view-popup[data-type="characteristics"]').live('click', function()
    {
        popupCharacteristics = new Popup('characteristics', 0, $(this));
        popupCharacteristics.open();
		return false;
        
        return false;
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
        var result = popupCharacteristics.getResult();
       
        /******* Здесь действия при сохраниении характеристик **********
        var insert = popupCategories.getCaused().parent().next();
        popupCategories.getCaused().parent().next().html(result);
        popupCategories.getCaused().parent().next().next().val(result);
        ****************************************************************/
        
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
        popupDescription = new Popup('description', $(this).text(), $(this));
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
       
        popupDescription.getCaused().html(result);
        popupDescription.getCaused().next().val(result);
        
        popupDescription.close();
        popupDescription = undefined;
        
        return false;
    });
    
    
    
    
    /* Выделение недели на странице ЗАГРУЗКИ БАНЕРА
     *
     */
    $('.load-banner .calendar tr').live('click', function(){
        if($(this).hasClass('selected'))
            $(this).removeClass('selected');
        else if(!$(this).hasClass('busy'))
            $(this).addClass('selected');
            
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
        
        if(value.length > limit)
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
function Popup(type, data, caused)
{
    this._popup = $('.popup[data-type="' + type + '"]');
    
    this._width = this._popup.outerWidth();
    this._height = this._popup.outerHeight();
    
    //Параметры по умолчанию
    this._caused = (typeof caused != "undefined") ? caused : false;
    this._data   = (typeof data != "undefined") ? data : false;
    
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
        
        this._state = true;
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
        return this._result.val();
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