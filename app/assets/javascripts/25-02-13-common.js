/**
 * POPUP 
 */
var popup = {
	
	//Состояние popup'а
	POPUP_STATE   : 0,
	//Открытая вкладка
	POPUP_TAB     : 0,
	//Состояние вкладки "Отзывы"
	POPUP_FB_ADD  : 0,

	/**
	 * Popup images
	 */
	block_image  : 'popup-image',
	block_images : 'lightbox',
	block_name   : 'popup-name',
	
	host_name    : location.protocol + "//" + location.hostname + ":" + location.port,
	
	controller   : null,
	entity_id    : null,
	model        : null,
	type         : null,
	
	yandexMap      : null,
	yandexMapFull  : null,

	/**
	 * Вставка изображений
	 * @param array images - массив объектов изображений
	 * @param string main_image - главное изображение
	 */
	insert_images : function(images, main_image)
	{
		$('.' + this.block_images).html('');
	
		$('.' + this.block_image + ' img').attr('src', main_image);
		$('.' + this.block_images).append('<li><a href="'+main_image+'"><img src="'+main_image+'" alt="" width="32" height="32" /></a></li>');
	
		if(images.length > 0)
		{
    		for(var i = 0; i < images.length; i++)
			{
				$('.' + this.block_images).append('<li><a href="'+images[i]['url'].url+'"><img src="'+images[i]['url'].url+'" alt="" width="32" height="32" /></a></li>');
			}
		}
      
		jQuery(".lightbox li a").lightBox({
			overlayOpacity: 0.7, containerResizeSpeed: 350, txtImage: 'Изображение', txtOf: 'из',
			imageLoading: '/assets/lightbox-btn-loading.gif', imageBtnClose: '/assets/lightbox-btn-close.gif',
			imageBtnPrev: '/assets/lightbox-btn-prev.gif', imageBtnNext: '/assets/lightbox-btn-next.gif'
		});
	},
	   
	/**
	 * Вставка общих данных которые имеются во всех сущностях
	 * @param object model - Сущность
	 */
	insert_common_data : function(model)
	{
		$('.popup-name a').text(model[0].title || model[0].name);
		$('.popup-company a').text(model[1].name);
		$('.popup-phone span').text(model[1].phone);
		$('.popup-address').text(model[1].address);
		
		$('.popup-map-title').attr('data-full-map', model[1].name + '::' + model[1].address);
		
		$('#entity_description .content-text').text(model[0].description || model[0].text);
	},
	
	/**
	 * Вставка данных компании
	 * @param object model - Сущность компании 
	 */
	insert_company_data : function(model)
	{
		$('.popup-name a').text(model[0].title || model[0].name);
		$('.popup-company a').text(model[0].name);
		$('.popup-phone span').text(model[0].phone);
		$('.popup-address').text(model[0].address);
		
		$('.popup-map-title').attr('data-full-map', model[0].name + '::' + model[0].address)
		
		$('#entity_description .content-text').text(model[0].description);
	},

	/**
	 * Загрузка схемы проезда (Yandex map API 2.0)
	 * @param string block - ID блока куда будет загружатся карта (по умолчанию #map)
	 * @param object company - Модель компании
	 * @param string user_adderss - Адрес пользователя, для установки маршрута
	 */
	map : function(block, company, user_address)
	{
		if (typeof user_address == "undefined") user_address = '';
		
		var companyPlacemark, userPlacemark;
		
		var companyGeocoder = ymaps.geocode("Оренбург, " + company.address);
		var userGeocoder;
		
		var companyCoords, userCoords;
		
		companyGeocoder.then(
		    function (res) {
		        companyCoords = res.geoObjects.get(0).geometry.getCoordinates();
		        
        		this.yandexMap = new ymaps.Map (block, {
				    center: companyCoords,
				    zoom: 15
				});
				
				companyPlacemark = new ymaps.Placemark(companyCoords, {
				    content: company.name,
					balloonContent: company.name
				});
				
				if(user_address != '')
				{
					userGeocoder = ymaps.geocode("Оренбург, " + user_address);
					
					userGeocoder.then(
						function(res_u)
						{
							userCoords = res_u.geoObjects.get(0).geometry.getCoordinates();
							userPlacemark = new ymaps.Placemark(userCoords, {
							    content: 'Ваш адрес',
								balloonContent: 'Ваш адрес'
							});
							
							//map.geoObjects.add(userPlacemark);
							
							ymaps.route(["Оренбург, " + user_address, "Оренбург, " + company.address]).then(
							    function (route) {
							        this.yandexMap.geoObjects.add(route);
							    },
							    function (error) {
							        alert('Возникла ошибка: ' + error.message);
							    }
							);
						},
						function(err_u)
						{
							alert('Ошибка');
						}
					);
				}
				
				this.yandexMap.geoObjects.add(companyPlacemark);
				// Создание экземпляра элемента управления
				this.yandexMap.controls.add('smallZoomControl');
		    },
		    function (err) {
		        alert('Ошибка');
		    }
		);
	},
	
	/**
	 * Обзор карты в расширенном виде
	 * @param string data - Данные для окна с картой
	 *                      [0] - Заголовок
	 *                      [1] - Адрес компании
	 *                      [2] - Адрес пользователя (для маршрута)
	 */
	mapFull : function(data)
	{
		split = data.split('::');
		
		var companyPlacemark, userPlacemark;
		
		var companyGeocoder = ymaps.geocode("Оренбург, " + split[1]);
		var userGeocoder;
		
		var companyCoords, userCoords;
		
		$('#map_full_title').text(split[0]);
		
		companyGeocoder.then(
		    function (res) {
		        companyCoords = res.geoObjects.get(0).geometry.getCoordinates();
		        
        		this.yandexMapFull = new ymaps.Map ('map_full', {
				    center: companyCoords,
				    zoom: 15
				}); 
				
				companyPlacemark = new ymaps.Placemark(companyCoords, {
				    content: split[0],
					balloonContent: split[0]
				});
				
				if(split[2])
				{
					userGeocoder = ymaps.geocode("Оренбург, " + split[2]);
					
					userGeocoder.then(
						function(res_u)
						{
							userCoords = res_u.geoObjects.get(0).geometry.getCoordinates();
							userPlacemark = new ymaps.Placemark(userCoords, {
							    content: 'Ваш адрес',
								balloonContent: 'Ваш адрес'
							});
							
							//map.geoObjects.add(userPlacemark);
							
							ymaps.route(["Оренбург, " + split[2], "Оренбург, " + split[1]]).then(
							    function (route) {
							        this.yandexMapFull.geoObjects.add(route);
							    },
							    function (error) {
							        alert('Возникла ошибка: ' + error.message);
							    }
							);
						},
						function(err_u)
						{
							alert('Ошибка');
						}
					);
				}
				
				this.yandexMapFull.geoObjects.add(companyPlacemark);
				// Создание экземпляра элемента управления
				this.yandexMapFull.controls.add('typeSelector');
				this.yandexMapFull.controls.add('zoomControl');
		    },
		    function (err) {
		        alert('Ошибка');
		    }
		);
	},
	
	/**
	 * Распределение загруженных данных в зависимости от типа сущности
	 */
	insert_data : function(type)
	{
		if(typeof type == 'undefined')
			type = '';
		else
			type = type + '_';
		
		switch(this.controller)
		{
			case "goods":
				this.insert_images(this.model[2], this.model[0]['image'].url);
				this.insert_common_data(this.model);
				$('#entity_characteristics .content-text').text(this.model[0].characteristics);
				$('#good_price').text(this.model[0].price);
				//this.map(type + 'map', this.model[1]);
			break;
			case "services":
				this.insert_images(this.model[2], this.model[0]['image'].url);
				this.insert_common_data(this.model);
				$('#service_cost_from').text(this.model[0].cost_from);
				$('#service_cost_to').text(this.model[0].cost_to);
				//this.map(type + 'map', this.model[1]);
			break;
			case "jobs":
				this.insert_images(this.model[2], this.model[0]['image'].url);
				this.insert_common_data(this.model);
				$('#job_salary_from').text(this.model[0].salary_from);
				$('#job_salary_to').text(this.model[0].salary_to);
				$('#entity_requirements .content-text').text(this.model[0].requirements);
				//this.map(type + 'map', this.model[1]);
			break;
			case "campaigns":
				this.insert_images(this.model[2], this.model[1]['logotype'].url);
				this.insert_common_data(this.model);
				//this.map(type + 'map', this.model[1]);
			break;
			case "companies":
				this.insert_images(this.model[2], this.model[0]['logotype'].url);
				this.insert_company_data(this.model);
				//this.map(type + 'map', this.model[0]);
			break;
		}
		
		$('#' + type + 'popup_tabs').css('display', 'block');
		$('#' + type + 'popup_header').css('display', 'block');
		$('#' + type + 'popup_loading').css('display', 'none');
	},
	
	/**
	 * Загрузка данных при открытии окна 
	 * @param string controller - Имя текущего контроллера
	 * @param integer entity_id - ID запрашиваемой сущности
	 */
	init : function(controller, entity_id)
	{
		this.entity_id  = entity_id;
		this.controller = controller;

		var url = this.host_name + "/" + this.controller + "/ajax/" + this.entity_id;
		
        $('.popup-slider').css('display','block');
        $('#mask').css('display','block');
		
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				popup.model = JSON.parse(xhr.responseText);
				popup.insert_data();
				//jQuery('.tab-content').jScrollPane();
			}
		});
	},
	
	/**
	 * Инициализация попапа на странице личного кабинета 
	 */
	init_ext : function(type, entity_id)
	{
		this.entity_id = entity_id;
		this.type = type;
		this.controller = (type == 'company') ? 'companies' : type + 's';
		
		var url = this.host_name + "/cabinet/ajax/" + entity_id + "/" + type;
		
		$('.popup-slider[data-type="' + type + '"]').css('display','block');
        $('#mask').css('display','block');
		
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				popup.model = JSON.parse(xhr.responseText);
				popup.insert_data(popup.type);
			}
		});
	},
	
	/**
	 * Удаление карты
	 */
	mapDestory : function()
	{
		$('#map').html('');
		this.yandexMap = null;
	},
	
	/**
	 * Удаление полной карты
	 */
	mapFullDestory : function()
	{
		$('#map_full').html('');
		this.yandexMapFull = null;
	},

	/**
	 * Переключение сущностей следующая/предыдущая
	 * @param string direction - Направление следующая или предыдущая 
	 */
	switching : function(direction, obj)
	{
		var params = window.location.search.substring(1); //Для учтения фильтров (пока не применяем)
		var url = this.host_name + "/" + this.controller + "/switching/" + this.entity_id + "/" + direction + "?" + params;
		
		//Скрываем Форму обратной связи если открыта
		this.hideFbAdd(obj);
		
		// Выводим индикатор загрузки
		$('#popup_tabs').css('display', 'none');
		$('#popup_header').css('display', 'none');
		$('#popup_loading').css('display', 'block');
		
		popup.mapDestory();
		
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				result = JSON.parse(xhr.responseText);
				if (result != 0)
				{
					popup.model = result
					popup.entity_id = popup.model[0].id
					popup.insert_data();
				}
				else
				{
					$('#popup_tabs').css('display', 'block');
					$('#popup_header').css('display', 'block');
					$('#popup_loading').css('display', 'none');
				}
			}
		});
	},
	
	/**
	 * Переключение сущностей следующая/предыдущая На странице ЛИЧНОГО КАБИНЕТА
	 * @param string direction - Направление следующая или предыдущая 
	 */
	switchingExt : function(direction, obj)
	{
		var type_one = ($('.cabinet-items').attr('data-one-type') == "true") ? true : false
		var url = this.host_name + "/cabinet/switching/" + this.entity_id + "/" + this.type + "/" + direction + "/" + type_one;
		
		//Скрываем Форму обратной связи если открыта
		this.hideFbAdd(obj);
		
		// Выводим индикатор загрузки
		$('#' + this.type + '_popup_tabs').css('display', 'none');
		$('#' + this.type + '_popup_header').css('display', 'none');
		$('#' + this.type + '_popup_loading').css('display', 'block');
		
		popup.mapDestory();
		
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				result = JSON.parse(xhr.responseText);
				if (result != 0)
				{
					$('.popup-slider').css('display', 'none');
					
					
					popup.type = result[3];
					popup.controller = (popup.type == 'company') ? 'companies' : popup.type + 's';
					
					$('.popup-slider[data-type="' + popup.type + '"]').css('display', 'block')
					
					popup.model = result
					popup.entity_id = popup.model[0].id
					popup.insert_data(popup.type);
				}
				else
				{
					$('#popup_tabs').css('display', 'block');
					$('#popup_header').css('display', 'block');
					$('#popup_loading').css('display', 'none');
				}
			}
		});
	},
	
	/**
	 * Отображение формы "Добавления отзыва"
	 * @param object obj - Попап в котором произошло событие 
	 */
	viewFbAdd : function(obj)
	{
		if(this.POPUP_FB_ADD == 0)
		{
			$('#popup_tabs').css('display', 'none');
			$('#popup_header').css('display', 'none');
			$('.feedback-add').css('display', 'block');
			this.POPUP_FB_ADD = 1
		}
	},
	
	/**
	 * Скрытие формы "Добавления отзыва"
	 * @param object obj - Попап в котором произошло событие 
	 */
	hideFbAdd : function(obj)
	{
		if(this.POPUP_FB_ADD == 1)
		{
			$('#popup_tabs').css('display', 'block');
			$('#popup_header').css('display', 'block');
			$('.feedback-add').css('display', 'none');
			this.POPUP_FB_ADD = 0
		}
	}

}

/**
 * Общий класс 
 */
var common = {
	
	/**
	 * Добавление в избранное или наоборот в игнор
	 * @param string type - Тип сущности (товар, услуга, компания)
	 * @param integer id - ID сущности
	 * @param integer status - Стату (1-В избранное, 0-В игнор)
	 * @param object parent_block - Блок в котором расположены кнопки добавления
	 */
	favorite : function(type, id, status, parent_block)
	{
		var url = popup.host_name + "/favorite/" + type + "/" + id + "/" + status;
		
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				result = JSON.parse(xhr.responseText);
				
				if (result == 1)
				{
					alert("Уже существует");
				}
				else if(result == 0)
				{
					alert("Произошла ошибка");
				}
				
				parent_block.next().css('display', 'none');
				parent_block.css('display', 'block');
				
			}
		});
		
	},
	
}

jQuery(document).ready(function($){

    /**
     * Используется:
     *   1. Для стрелки кнопки расширенного поиска
     */
    var dir_images = '/assets/';
    
    /**
     * ! Событие
     * Сортировка сущностей 
     */
    $("#sort").selectbox().bind('change', function(){
       	if($(this).val() != 'empty')
			location.href = location.protocol + "//" + location.hostname + ":" + location.port + $(this).val();
	 
    });
	$('#sort').live('change', function(){
		if($(this).val() != 'empty')
			location.href = location.protocol + "//" + location.hostname + ":" + location.port + $(this).val();
	});
	
	$('.other-selectbox').selectbox();
	
	/**
	 * ! Событие
	 * Фильтр на страницах сущностей
	 *   Задача: собрать url запроса исходя из правил фильтра которые задал пользователь 
	 */
	$('#filter').live('click', function()
	{
		var url = window.location.search.substr(1).split("&");
		var param = {};
		var result = '/' + $('body').attr('data-controller') + '?';
		
		for(var i = 0; i < url.length; i++)
		{
			var tmp = url[i].split('=');
			param[tmp[0]] = tmp[1];
		}
		
		$('.filter').each(function()
		{
			if($(this).val() != 'empty')
			{
				if($(this).attr('type') == 'checkbox')
				{
					if($(this).attr("checked") == 'checked')
						param[$(this).attr('name')] = 1;
					else if(typeof param[$(this).attr('name')] != 'undefined')
						delete param[$(this).attr('name')];
				}
				else if($(this).attr('type') == 'text')
				{
					if($(this).val() != '')
						param[$(this).attr('name')] = $(this).val();
				}	
				else
				{
					param[$(this).attr('name')] = $(this).val();
				}
			}
			else
			{
				if(typeof param[$(this).attr('name')] != 'undefined')
					delete param[$(this).attr('name')];
			}	
			
			if(typeof param[$(this).attr('name')] != 'undefined' && $(this).val() == '')
				delete param[$(this).attr('name')];
		});
		
		for (p in param)
		{
			if(typeof param[p] != 'undefined')
			result += p + '=' + param[p] + '&'
		}
		
		result = result.substring(0, result.length - 1)

		location.href = location.protocol + "//" + location.hostname + ":" + location.port + result
	});
	
	/**
	 * ! Событие
	 * Добавление в избранное
	 * И наоборот в черный список 
	 */
	$('.favorite').live('click', function()
	{
		var param = $(this).attr('data-favorite').split(':');
		var parent_block = $(this).parent();
		
		parent_block.css('display', 'none');
		parent_block.next().css('display', 'block');
		
		common.favorite(param[0], param[1], param[2], parent_block);
		
		return false;
	});
	
    /**
     * ! Событие
     * Открытие попапа 
     */
    $('.item-title a, .item-image a, .item-text').live('click', function()
    {
        id = $(this).attr('data-item-id');
        controller = $('body').attr('data-controller');
        
		popup.init(controller, id)
        
        return false;
    });
    
    /**
     * ! Событие
     * Открытие формы обратной связи 
     */
    $('.fb-add a').live('click', function()
    {
    	var popup_block = $(this).parents('.popup-slider');
    	popup.viewFbAdd(popup_block);
    	return false;
    });
    
    /**
     * ! Событие
     * Открытие формы обратной связи 
     */
    $('.fb-close').live('click', function()
    {
    	var popup_block = $(this).parents('.popup-slider');
    	popup.hideFbAdd(popup_block);
    	return false;
    });
    
    /**
     * ! Событие
     * Открытие попапа НА СТРАНИЦЕ ЛИЧНОГО КАБИНЕТА
     */
    $('.cabinet-item-title a, .cabinet-item-image a, .cabinet-item-text').live('click', function()
    {
        id = $(this).attr('data-item-id');
        type = $(this).attr('data-item-type');
        
        popup.init_ext(type, id);
        
        return false;
    });
    
    /**
     * ! Событие
     * Пререключение сущностей в попапе 
     */
    $('#popupNext').live('click', function(){
    	var popup_block = $(this).parents('.popup-slider');
    	popup.switching('next', popup_block);
    });
    $('#popupPrev').live('click', function(){
    	var popup_block = $(this).parents('.popup-slider');
    	popup.switching('prev', popup_block);
    });
    
    /**
     * ! Событие
     * Пререключение сущностей в попапе 
     */
    $('#popupExtNext').live('click', function(){
    	popup.switchingExt('next');
    });
    $('#popupExtPrev').live('click', function(){
    	popup.switchingExt('prev');
    });
    
    /**
     * ! Событие
     * Закрытие попапа 
     */
    $('.popup-close a').live('click', function()
    {
        $(this).parent().parent().parent().css('display', 'none');
        $('#popup_tabs').css('display', 'none');
        $('#popup_header').css('display', 'none');
        $('#mask').css('display','none');
		$('#popup_loading').css('display', 'block');
		
		popup.mapDestory();
		popup.hideFbAdd($(this).parent().parent().parent());
		
        return false;
    });
    
    /**
     * Вкладки в попапе 
     */
    var zindex = 4000 + $('.other-tabs li').length;
    
    $('.other-tabs li').each(function()
    {
        $(this).css('z-index', zindex);
        zindex--;
    });
    $('.other-tabs li').live('click', function()
    {
        var last_zindex = 4000 + $('.other-tabs li').length;
        var id = $(this).attr('data-other-tab');
        
        $('.tab-curent').removeClass('tab-curent');
        
        $('.other-tabs li').each(function()
        {
            $(this).css('z-index', last_zindex);
            last_zindex--;
        });
        
        $(this).addClass('tab-curent');
        $(this).css('z-index', '4025');
        
        $('.tab-content').css('display', 'none');
        $('div[data-other-con="' + id + '"]').css('display', 'block');
    });
    
    /**
     * Вкладки на главной 
     */
	var main_zindex = 100;

	$('.new-other-tabs li').each(function()
    {
        $(this).css('z-index', zindex);
        zindex--;
    });
    $('.new-other-tabs li').live('click', function()
    {
        var parent = $(this).parent().parent().parent();
        var last_zindex = 100 + $('.new-other-tabs li', parent).length;
        var id = $(this).attr('data-other-tab');
        
        $('.new-tab-curent', parent).removeClass('new-tab-curent');
        
        $('.new-other-tabs li', parent).each(function()
        {
            $(this).css('z-index', last_zindex);
            last_zindex--;
        });
        
        $(this).addClass('new-tab-curent');
        $(this).css('z-index', '125');
        
        $('.new-tab-content', parent).css('display', 'none');
        $('div[data-other-con="' + id + '"]', parent).css('display', 'block');
        
	});

    /**
     * ! Событие
     * Открытие окна с схемой проездаы 
     */
    $('.view-map-full').live('click', function()
    {
    	popup.mapFullDestory();
    	
    	$('#mask').show();
    	$('.map-full').show();
    	
    	popup.mapFull($(this).attr('data-full-map'));
    	
    	return false;
    });
    
    /**
     * ! Событие
     * Закрытие окна с схемой проездаы 
     */
    $('.map-full #map_full_close').live('click', function()
    {
    	$(this).parent().parent().parent().hide();
    	$('#mask').hide();
    	return false;
    });
    
    /**
     * ! Событие
     * Открытие окна с видео на главной странице из блока "Знакомство с системой"
     */
	$('.about-video').live('click', function()
	{
		var video_id = $(this).attr('data-about');
		$('#mask').show();
		$('#video_about_' + video_id).show();
	});
    /**
     * ! Событие
     * Закрытие окна с видео на главной странице
     */
    $('.video-about-close').live('click', function()
    {
    	$(this).parent().parent().parent().hide();
    	$('#mask').hide();
    	return false;
    });
    
    /**
     * ! Событие
     * Отображение/скрытие категорий или подкатегори в правом блоке
     */
    $('.sub_nav ul li a').live('click', function()
    {
        if($('ul', $(this).parent()).css('display') == 'none')
        {
            $('ul', $(this).parent()).show(200);
            $('ul li ul', $(this).parent()).css('display', 'none');
        }
        else
        {
            $('ul', $(this).parent()).hide(200);
        }
        if($(this).attr('class') == 'menu-level-2')
        	return true;
        return false;
    });
    
    /**
     * ! Событие
     * Переключение видеороликов на главной
     */
    $('.button-video').live('click', function()
    {
        var id = $(this).attr('data-video-button-id');
        
        $('.block-video').each(function()
        {
            if($(this).attr('data-video-id') == id)
            {
                $(this).css('display', 'block');
            }
            else
            {
                $(this).css('display', 'none');
            }
        })
    });
    
    /**
     * ! Событие
     * Переключения вкладок в блоке с вкладками в контенте
     */
    $('.with-tabs li').live('click', function()
    {
        var id = $(this).attr('data-tab');
        
        $('.sub-cont', $(this).parent().parent().next()).each(function()
        {
            if($(this).attr('data-con') == id)
            {
                $(this).css('display', 'block');
            }
            else
            {
                $(this).css('display', 'none');
            }
        });
        
        $('.tab-active', $(this).parent()).removeClass('tab-active');
        $(this).addClass('tab-active');
    });

    
    //слайды в контенте в блоке с вкладками
    declareCarousel($('#cont_slider_1'), '#cont_slider_prev_0', '#cont_slider_next_0');
    declareCarousel($('#cont_slider_2'), '#cont_slider_prev_1', '#cont_slider_next_1');
    declareCarousel($('#cont_slider_3'), '#cont_slider_prev_2', '#cont_slider_next_2');
    
    declareCarousel($('#cont_slider_4'), '#cont_slider_prev_4', '#cont_slider_next_4');
    
    $('.new-tab-content').css('display', 'none');
    $('.new-tab-content[data-other-con="1"]').css('display', 'block');
    
    
    /*
     * Слайдер в шапке
     */
    $('.slider-cont').jCarouselLite({
        btnNext: '.slide-next',
        btnPrev: '.slide-prev',
        visible: 1,
        speed: 500,
        auto: 7000,
        start: 0,
        circular: true,
        hoverPause: true
    });
    
    /**
     * Слайдер - новые компании на странице вывод компаний 
     */
    $('#newCompanyContent').jCarouselLite({
        visible: 5,
        speed: 500,
        auto: 2500,
        start: 0,
        circular: true,
        hoverPause: true
    });
    
    /*
     * Слайдер знакомство с системой bannerSlider
     */
    var count_tutorials = $('#about_slider_buttons li').length;
    var about_id = new Array(count_tutorials);
    var aid = 0;
    if(count_tutorials > 0)
    {
      $('#about_slider_buttons li').each(function(){
          about_id[aid] = '#' + $(this).attr('id')
          aid++;
      });
      
      $('#about_slider_slides').jCarouselLite({
          btnGo: about_id,
          visible: 1,
          speed: 500,
          auto: 10000,
          start: 0,
          circular: true,
          hoverPause: true,
          afterEnd:
              function(a, to, btnGo)
              {
                  if(btnGo.length <= to){
                      to = 0;
                  }
                  $('.slide-active').removeClass('slide-active');
                  $(btnGo[to]).addClass('slide-active');
              }
      });
    }
    
    /*
     * Слайдер баннеров на второстепенных страницах
     * 
     * ВНИМАНИЕ!!! Размер картинки - WIDTH:595, HEIGHT:188
     * 
     */
    $('#bannerSlider ul li').css('width', 595 + 'px');
    $('#bannerSlider ul li').css('height', 188 + 'px');
    
    
    var count_banners = $('.banner-buttons li').length;
    var banners_id = new Array(count_banners);
    var bid = 0;
    
    var TOTAL_ITEMS = $('.banner-buttons li').length;
    var randNum = Math.floor(Math.random()*(TOTAL_ITEMS));

    if(count_banners > 1)
    {    
      $('.banner-buttons li').each(function(){
        banners_id[bid] = '#' + $(this).attr('id')
        if(bid == randNum)
        	$(this).addClass('banner-but-active');
        bid++;
      });
      
      $(this).addClass('banner-but-active');

      $('#bannerSlider').jCarouselLite({
          btnGo: banners_id,
          visible: 1,
          speed: 500,
          auto: 10000,
          circular: true,
          vertical: false,
          hoverPause: true,
          start: randNum,
          afterEnd:
              function(a, to, btnGo)
              {
                  if(btnGo.length <= to){
                      to = 0;
                  }

                  $(btnGo[to]).animate(
                  {
                      'margin' : '-1px 50px -1px -50px',
                      'text-align': 'left',
                      'background': '#52dbfd',
                      'border': '1px solid #cccccc',
                      'padding': '8px 0px 7px 20px'
                  }, 300).addClass('banner-but-active');
                  
                  $('#bannerView a').attr('href', $(btnGo[to]).attr('data-view-url'));
              },
			beforeStart:
              function(a)
              {
                  var count = $('.banner-buttons li').length;
                  
                  $('.banner-but-active').animate(
                  {
                      'margin' : '-1px 0px -1px 0px',
                      'text-align': 'center',
                      'background': '#fff',
                      'border': '1px solid #cccccc',
                      'padding': '8px 0px 7px 20px'
                      
                  }, 300).removeClass('banner-but-active');
              }
      });
    }
    //end slider
    
    
    if($('.carousel-all').length > 0)
    {
        /**
        $('.carousel-all').kepCarousel({
            btnPrev : '.slide-prev',
            btnNext : '.slide-next',
            auto : true,
            time : 8000
        });
        $('.carousel-all').width(5000)
            */
        carousel($('.carousel-all'));
    }
    
    //Отображение расширенного поска
    $('#search_ext_view').live('click', function()
    {
        var block = $('#search_ext');
        
        if(block.css('display') == 'none')
        {
            block.slideDown(300);
            $('img', $(this)).attr('src', dir_images + 'hide-search.png');
        }
        else
        {
            block.slideUp(300);
            $('img', $(this)).attr('src', dir_images + 'view-search.png');
        }
        return false;
    });
    
    /**
     * Отображение блока регистрации
     */
    $('#view_registration').live('click', function()
    {
        var block = $('#registration');
    
        if(block.css('display') == 'none')
        {
            block.css('display','block');
        }
        else
        {
            block.css('display','none');
            clearTab(); return false;
        }
        
        $('#login').css('display', 'none');
        $('#add').css('display', 'none');
        
        changeTopTab($(this));
        
        return false;
    });
    
    /**
     * Отображение блока входа
     */    
    $('#view_login').live('click', function()
    {
        var block = $('#login');
    
        if(block.css('display') == 'none')
        {
            block.css('display','block');
        }
        else
        {
            block.css('display','none');
            clearTab(); return false;
        }
        
        $('#registration').css('display', 'none');
        $('#add').css('display', 'none');
        
        changeTopTab($(this));
        
        return false;
    });
    
    /**
     * Отображение блока добавить
     */   
    $('#view_add').live('click', function()
    {
        var block = $('#add');
    
        if(block.css('display') == 'none')
        {
            block.css('display','block');
        }
        else
        {
            block.css('display','none');
            clearTab(); return false;
        }
        $('#registration').css('display', 'none');
        $('#login').css('display', 'none');
        
        changeTopTab($(this), false);
        
        return false;
    });
    
    /**
     * Скрытие вышеописанных блоков 
     */
    $('#slider, #left, #content, #search, #header_main, #main_nav, #last_footer, #header_righ').click(function(e)
    {
        $('#registration').css('display','none');
        $('#login').css('display','none');
        $('#add').css('display','none');
        
        clearTab();
    });
    
    /**
     * Блок востановление пароля
     */
    $('#view_rec_pass').live('click', function()
    {
        $('.popup-pass').css('display','block');
        return false;
    });
    $('.popup-pass-close a').live('click', function()
    {
        $(this).parent().parent().css('display', 'none');
        $('#mask').css('display','none');
        return false;
    });
   
    
    /**
     * Открытие/раскрытие блока с отзывом
     *
     */
    $('.review-view').live('click', function()
    {
        var review = $(this).closest('article');
        
        if($('.detail-full', review).css('display') == 'none')
        {
            $('.detail-full', review).css('display', 'block');
            $('.detail-mini', review).css('display', 'none');
            $('.review-other', review).css('display', 'block');
            
            $('.review-title a', review).css('color', '#ff6600');
        }
        else
        {
            $('.detail-full', review).css('display', 'none');
            $('.detail-mini', review).css('display', 'block');
            $('.review-other', review).css('display', 'none');
            
            $('.review-title a', review).css('color', '#45dafe');
        }
        
        return false;
    });
    
    /**
     * Замена селектов
     */
    $(".form select").selectbox();

    $("#area").selectbox().bind('change', function(){
        // !!!!Пишем код при смене значения
    });
    
    
    /**
     * Отображение/скрытие дочерних категорий
     */
    $('.branch-view').live('click', function()
    {
        var li = $(this).parent('li');
        
        if($('ul', li).css('display') == 'none')
        {
            $('ul', li).css('display', 'block');
            $('ul li ul', li).css('display', 'none');
            $(this).attr('src', dir_images + 'list-item-open.png');
        }
        else
        {
            $('ul', li).css('display', 'none');
            $(this).attr('src', dir_images + 'list-item-close.png');
        }

    });
    
    /**
     * Маска
     */
    $('#mask').width($(document).width());
    $('#mask').height($(document).height());
    
    /**
     * Фотогалерея
     */
    if($('.lightbox').length > 0)
    {
        jQuery(".lightbox li a").lightBox({
            overlayOpacity: 0.7,
            imageLoading: dir_images + 'lightbox-btn-loading.gif',
            imageBtnClose: dir_images + 'lightbox-btn-close.gif',
            imageBtnPrev: dir_images + '/lightbox-btn-prev.gif',
            imageBtnNext: dir_images + 'lightbox-btn-next.gif',
            containerResizeSpeed: 350,
            txtImage: 'Изображение',
            txtOf: 'из'
        });
    }
    
    
      
/*-------------------------------------------------------------------------------------------
 | ЛИЧНЫЙ КАБИНЕТ ПОЛЬЗОВАТЕЛЯ
 *------------------------------------------------------------------------------------------*/  
        
    /**
     * Открытие/скрытие пунктов меню в кабинете пользователя
     */
    var curent_id = 0;
    $('.left-menu-tit a').live('click', function()
    {
        var id = $(this).attr('rel');
        if(id != curent_id)
        {
            curent_id = id;
            
            $('.left-menu-content').slideUp(200);
            $('#menu_content_' + id).slideDown(200);
        }
        return false;
    });
    
    /**
     * Фильтрация сущностей в контенте На главной
     */
    $('.filter-view-type').live('change', function()
    {
		var filter  = $.cookie('filter_view').split(':');
    	var state   = ($(this).attr("checked") == 'checked') ? true : false;
    	var name    = $(this).attr("name");
    	var result  = '';
    	var flag    = false;
    	
    	$.removeCookie('filter_view');
    	
    	for(var i = 0; i < filter.length; i++)
    	{
			if(filter[i] == name && !state)
			{
				flag = true;
				continue;
			}
			
			result += filter[i] + ':';
    	}
    	
    	if(!flag && state)
    	{
    		result += name + ':';
    	}
    	
    	result = result.substring(0, result.length - 1)
    	
    	$.cookie('filter_view', result, { expires: 70 });
    	
    	location.href = window.location
    });

});

/**
 * Объявление карусели 
 */
function declareCarousel(obj, prev, next)
{
	if($('ul li', obj).length > 0)
	    obj.jCarouselLite({
	        btnNext: next,
	        btnPrev: prev,
	        visible: 4,
	        speed: 500,
	        start: 0,
	        circular: false
	    });
}

function changeTopTab(obj)
{

        var ul =  $(obj).closest('ul');
        var li =  $(obj).parent('li');

        $('.top-nav').each(function() //hasClass()
        {
            $(this).removeClass('top-nav-active');
        });

        li.addClass('top-nav-active');

        var prev=0, i=0, curent=0;
        var liall = new Array($('.top-nav').length);

        $('.top-nav').each(function()
        {
            if($(this).hasClass('top-nav-active'))
            {
                curent = i; prev = curent-1;
            }
            liall[i] = $(this);
            i++;
        });

        for(j=0; j<$('.top-nav').length; j++)
        {
            if(j == prev)
            {
                liall[j].css('border','none');
                liall[j].css('padding','0px 5px 0px 6px');
            }
            else if(j != $('.top-nav').length - 1)
            {
                liall[j].css('border-right','1px solid #fff');
                liall[j].css('padding','0px 4px 0px 6px');
            }
        }
        li.css('padding','1px 4px 4px 6px');
        
        /**
         * 
         */
        $('.send-resume').live('click', function()
        {
            var id = $(this).attr('id')[2];
        });
}

function clearTab()
{
    var i = 0;
    $('.top-nav').each(function()
    {
        if($(this).hasClass('top-nav-active'))
        {
            $(this).removeClass('top-nav-active');
        }
        if(i < $('.top-nav').length - 1)
        {
            $(this).css('border-right','1px solid #fff');
        }
        $(this).css('padding','0px 4px 0px 6px');
        i++;
    });
}


function var_dump(arr,level) {
  var dumped_text = "";
  if(!level) level = 0;

  //The padding given at the beginning of the line.
  var level_padding = "";
  for(var j=0;j<level+1;j++) level_padding += "    ";

  if(typeof(arr) == 'object') { //Array/Hashes/Objects
   for(var item in arr) {
    var value = arr[item];
   
    if(typeof(value) == 'object') { //If it is an array,
     dumped_text += level_padding + "'" + item + "' ...\n";
     dumped_text += var_dump(value,level+1);
    } else {
     dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
    }
   }
  } else { //Stings/Chars/Numbers etc.
   dumped_text = "===>"+arr+"<===("+typeof(arr)+")";
  }
  return dumped_text;
}