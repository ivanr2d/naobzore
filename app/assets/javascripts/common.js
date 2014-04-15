if (!NB) var NB = {}
/**
 * POPUP 
 */
var popup = {
	
	//Блок попапа
	popUp : null,
	
	//Состояние
	state : 0,
	//Активная вкладка
	tab : 0,
	
	//Данные сущности
	entity_id   : null,
	entity_type : null,
	controller  : null,
	
	//Имя хоста
	host_name    : location.protocol + "//" + location.hostname + ":" + location.port,
	
	//Ответ
	answer  : [],
	header  : '',
	content : '',
	
	yandexMap      : null,
	yandexMapFull  : null,
	
	message : '',
	message_status : 1,
	
	/**
	 * Инициализация после загрузки страницы 
	 */
	init : function()
	{
		
	},
	
	/**
	 * Открытие
	 */
	open : function(entity_id, entity_type, controller)
	{
		this.entity_id = entity_id;
		this.entity_type = entity_type;
		this.controller = controller;
		
		var url = this.host_name + "/" + this.controller + "/ajax/" + this.entity_id + "/" + this.entity_type;
		
        $('.popup-slider').css('display','block');
        $('#mask').css('display','block');
        
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				popup.answer = JSON.parse(xhr.responseText);
				popup.put();
				popup.hideIndicator();
				//alert(var_dump(popup.answer));
				//jQuery('.tab-content').jScrollPane();
			}
		});
		
	},
	
	/**
	 * Закрытие 
	 */
	close : function()
	{
		$('#popupHeader').html('');
		$('#popupContent').html('');
		
		this.mapDestory();
		
    	this.hideFeedbackForm();
    	
    	this.tab = 0;
    	this.message = '';
		
        $('.popup-slider').css('display','none');
        $('#mask').css('display','none');
	},
	
	/**
	 * Переключение 
	 */
	switching : function(direction)
	{
		var category = ($('#currentCategory').length > 0 && $('#currentCategory').attr('data-value') != 0) ? $('#currentCategory').attr('data-value') + '/' : '';
		var params = window.location.search.substring(1); //Для учтения фильтров (пока не применяем)
		var url = this.host_name + "/" + this.controller + "/switching/" + category + this.entity_id + "/" + direction + "?" + params;
		
		$('#popupHeader').html('');
		$('#popupContent').html('');
    	this.message = '';
		
		this.mapDestory();
    	this.hideFeedbackForm();
    	this.showIndicator();
	
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				popup.answer = JSON.parse(xhr.responseText);
				
				popup.entity_id = popup.answer[10].id;
				
				popup.put();
				popup.hideIndicator();
			}
		});
	},
	
	/**
	 * Вставка данных 
	 */
	put : function()
	{
		$('#popupHeader').html(this.answer[1]);
		$('#popupContent').html(this.answer[2]);
		$('#feedbackForm').html(this.answer[3]);
		
		this.tabs();
		
		this.map('map', this.answer[0]);
		
		jQuery(".lightbox li a").lightBox({
			overlayOpacity: 0.7, containerResizeSpeed: 350, txtImage: 'Изображение', txtOf: 'из',
			imageLoading: '/assets/lightbox-btn-loading.gif', imageBtnClose: '/assets/lightbox-btn-close.gif',
			imageBtnPrev: '/assets/lightbox-btn-prev.gif', imageBtnNext: '/assets/lightbox-btn-next.gif'
		});
		
		$('#popup_notic').html(this.message);
		$('#popup_notic').css('color', this.message_status == 1 ? 'green' : 'red')
	},
	
	/**
	 * Применение стилей к вкладкам 
	 */
	tabs : function()
	{
	    var zindex = 2000 + $('.other-tabs li').length;
	    
	    $('.other-tabs li').each(function()
	    {
	        $(this).css('z-index', zindex);
	        zindex--;
	    });
	    
	    $('.other-tabs li').live('click', function()
	    {
	        var last_zindex = 2000 + $('.other-tabs li').length;
	        var id = $(this).attr('data-other-tab');
	        
	        $('.tab-curent').removeClass('tab-curent');
	        
	        $('.other-tabs li').each(function()
	        {
	            $(this).css('z-index', last_zindex);
	            last_zindex--;
	        });
	        
	        $(this).addClass('tab-curent');
	        $(this).css('z-index', '2025');
	        
	        $('.tab-content').css('display', 'none');
	        $('div[data-other-con="' + id + '"]').css('display', 'block');
	    });
	    
	    if(this.tab != 0)
	    {
	        var last_zindex = 2000 + $('.other-tabs li').length;
	        var id = this.tab
	        var tab = $('li[data-other-tab="' + id + '"]');
	        
	        $('.tab-curent').removeClass('tab-curent');
	        
	        $('.other-tabs li').each(function()
	        {
	            $(this).css('z-index', last_zindex);
	            last_zindex--;
	        });
	        
	        tab.addClass('tab-curent');
	        tab.css('z-index', '2025');
	        
	        $('.tab-content').css('display', 'none');
	        $('div[data-other-con="' + id + '"]').css('display', 'block');
	    }
	},
	
	/**
	 * Отображение индикатора загрузки 
	 */
	showIndicator : function()
	{
		$('#popupContent').css('display', 'none');
		$('#popupHeader').css('display', 'none');
		$('.feedback-add').css('display', 'none');
		$('#popup_loading').css('display', 'block');
	},

	/**
	 * Отображение индикатора загрузки
	 */	
	hideIndicator : function()
	{
		$('#popupContent').css('display', 'block');
		$('#popupHeader').css('display', 'block');
		$('#popup_loading').css('display', 'none');
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
	 * Отображение формы "Добавления отзыва"
	 * @param object obj - Попап в котором произошло событие 
	 */
	showFeedbackForm : function()
	{
		this.message = '';
		$('#popup_notic').html(this.message);
		$('#popupContent').css('display', 'none');
		$('#popupHeader').css('display', 'none');
		$('.feedback-add').css('display', 'block');
	},
	
	/**
	 * Скрытие формы "Добавления отзыва"
	 * @param object obj - Попап в котором произошло событие 
	 */
	hideFeedbackForm : function()
	{
		this.message = '';
		$('#popup_notic').html(this.message);
		$('#popupContent').css('display', 'block');
		$('#popupHeader').css('display', 'block');
		$('.feedback-add').css('display', 'none');
	},
	
	viewHideFullText : function(obj)
	{
		if($('.popup-fb-mini-text', obj).css('display') == 'block')
		{
			$('.popup-fb-mini-text', obj).css('display', 'none');
			$('.popup-fb-full-text', obj).css('display', 'block');
		}
		else if($('.popup-fb-mini-text', obj).css('display') == 'none')
		{
			$('.popup-fb-mini-text', obj).css('display', 'block');
			$('.popup-fb-full-text', obj).css('display', 'none');
		}
	},
	
	viewHideFullTextCommon : function(obj)
	{
		if($('.popup-text-mini', obj).css('display') == 'block')
		{
			$('.popup-text-mini', obj).css('display', 'none');
			$('.popup-text-full', obj).css('display', 'block');
		}
		else if($('.popup-text-mini', obj).css('display') == 'none')
		{
			$('.popup-text-mini', obj).css('display', 'block');
			$('.popup-text-full', obj).css('display', 'none');
		}
	},
	
	/**
	 * Отправка отзыва на сервер 
	 */
	sendFeedback : function()
	{
		var data = '';
		var url  = this.host_name + "/feedbacks/add"
		var token = $("meta[name='csrf-token']").attr("content");
		var valid = true;
		var error = '';
		this.message = '';
		
		//Базовые поля
		$('#feedbackAdd input[type="hidden"]').each(function()
		{
			data += $(this).attr('name') + '=' + $(this).val() + '&';
		});
		
		//Поля отзыва
		$('#feedbackAdd textarea').each(function()
		{
			if($(this).val() == '')
			{
				valid = false;
				$(this).css('border-color', 'red');
				error = 'Необходимо заполнить обязательные поля. Пожалуйста заполните выделенные поля.';
			}
			else data += $(this).attr('name') + '=' + $(this).val() + '&';
		});
		
		$('#feedbackAdd input[type="radio"]').each(function()
		{
			if($(this).attr('checked') == 'checked')
			{
				data += $(this).attr('name') + '=' + $(this).val() + '&';
			}
		});
		
		if(valid)
		{
			this.showIndicator();
			
			$.ajax({
				type : "POST",
				url  : url,
				data : data,
	  			beforeSend : function(xhr)
	  			{
	                  xhr.setRequestHeader("Accept", "text/javascript");
	                  xhr.setRequestHeader("X-CSRF-Token", token);
	           	},
				complete: function(xhr)
				{
					result = JSON.parse(xhr.responseText);
					
					if(result == 1)
					{
						popup.open(popup.entity_id, popup.entity_type, popup.controller);
						popup.tab = 3;
						popup.message = 'Отзыв добавлен!';
						popup.message_status = 1;
					}
					else if(result == 3)
					{
						popup.open(popup.entity_id, popup.entity_type, popup.controller);
						popup.tab = 3;
						popup.message = 'Вы уже добавили отзыв';
						popup.message_status = 0;
					}
				}
			});
		}
		else
		{
			$('.fb-error').html(error);
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
	favorite : function(type, id, status, parent_block, elem)
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
					showAlert("Удалено из&nbsp;личного кабинета.");
					$(elem).removeClass('actived');
				}
				else if(result == 0)
				{
					showAlert("Произошла ошибка");
				}else {
					showAlert("Добавлено в&nbsp;личный кабинет!");
					$(elem).addClass('actived');
				}
				
				parent_block.next().css('display', 'none');
				parent_block.css('display', 'block');
				
			}
		});
		
	},
	
	/**
	 * Добавление лайка
	 * @param string type - Тип сущности (товар, услуга, компания)
	 * @param integer id - ID сущности
	 * @param object parent_block - Блок в котором расположены кнопки добавления
	 */
	like : function(type, id, parent_block)
	{
		var url = popup.host_name + "/like/" + type + "/" + id;
		
		$.ajax({
			type: "GET",
			url: url,
			complete: function(xhr)
			{
				result = JSON.parse(xhr.responseText);
				
				if (result == 1)
				{
					count = $('.like-count', parent_block).text();
					$('.like-count', parent_block).text(Number(count) - 1);
				}
				else if(result == 0)
				{
					alert("Произошла ошибка");
				}
				
				parent_block.next().css('display', 'none');
				parent_block.css('display', 'block');
				
				if(result == 2)
				{
					count = $('.like-count', parent_block).text();
					$('.like-count', parent_block).text(Number(count) + 1);
				}
			}
		});
		
	}
	
}

/**
 * События 
 */
jQuery(document).ready(function($){

    /**
     * Используется:
     *   1. Для стрелки кнопки расширенного поиска
     */
    var dir_images = '/assets/';
    
    /**
     * Отображение карты на страницах обзора 
     */
    if($('#viewMap').length > 0)
    {
    	ymaps.ready(function(){
	    	var data = $('#viewMap').attr('data-map').split('::');
	    	company = {address:data[0], name:data[1]};
	    	
	    	popup.map('map', company)
    	});
    }
    
    /**
     * ! Событие
     * Сортировка сущностей 
     */
    $("#sort").selectbox({animationSpeed: 50}).bind('change', function(){
       	if($(this).val() != 'empty')
			location.href = location.protocol + "//" + location.hostname + ":" + location.port + $(this).val();
    });
	$('#sort').live('change', function(){
		if($(this).val() != 'empty')
			location.href = location.protocol + "//" + location.hostname + ":" + location.port + $(this).val();
	});
	
	$('.other-selectbox').selectbox({animationSpeed: 50}).bind('change', function(){
       	filter();
    });
	
	/**
	 * ! Событие
	 * Фильтр на страницах сущностей
	 *   Задача: собрать url запроса исходя из правил фильтра которые задал пользователь
	 * С 25.03.2013 - НЕ ИСПОЛЬЗУЕТСЯ
	 */
	$('#filter').live('click', function()
	{
		filter();
	});
	
	//Максимальная цена
	var max_num = (typeof($('#maxPrice').attr('data-value')) != 'undefined' && $('#maxPrice').attr('data-value') != '') ? $('#maxPrice').attr('data-value') : 1000000000;
			
	/**
	 * Фильтр цент товаров 
	 */
	if($('#polzunok_good_price').length > 0)
	{
		var from = (get_param('price_from')) ? get_param('price_from') : 0;
		var to = (get_param('price_to')) ? get_param('price_to') : max_num;
		
		UISlider("#polzunok_good_price", "input#price_from", "input#price_to", 0, max_num, from, to, '');	//was callback - 'filter' 
	}
	
	/**
	 * Фильтр цент услуг
	 */
	if($('#polzunok_service_cost').length > 0)
	{
		var from = (get_param('cost_from')) ? get_param('cost_from') : 0;
		var to = (get_param('cost_to')) ? get_param('cost_to') : max_num;
		
		UISlider("#polzunok_service_cost", "input#cost_from", "input#cost_to", 0, max_num, from, to, ''); //was callback - 'filter' 
	}
	
	/**
	 * Фильтр цент услуг
	 */
	if($('#polzunok_job_salary').length > 0)
	{
		var from = (get_param('salary_from')) ? get_param('salary_from') : 0;
		var to = (get_param('salary_to')) ? get_param('salary_to') : max_num;
		
		UISlider("#polzunok_job_salary", "input#salary_from", "input#salary_to", 0, max_num, from, to, ''); //was callback - 'filter' 
	}
	
	/**
	 * Фильр по чекбоксам
	 */
	$('.filter-element input[type="checkbox"]').live('click', function()
	{
		filter();
	});   
	
	/**
	 * ! Событие
	 * Добавление в избранное
	 * И наоборот в черный список 
	 */
	$('.favorite, .ignore').live('click', function()
	{
		var param = $(this).attr('data-favorite').split(':');
		var parent_block = $(this).parent();
		
		parent_block.css('display', 'none');
		parent_block.next().css('display', 'block');
		
		common.favorite(param[0], param[1], param[2], parent_block, this);
		
		return false;
	});
	
	/**
	 * ! Событие
	 * Добавление в избранное
	 * И наоборот в черный список 
	 */
	$('.like').live('click', function()
	{
		var param = $(this).attr('data-like').split(':');
		var parent_block = $(this).parent();
		
		parent_block.css('display', 'none');
		parent_block.next().css('display', 'block');
		
		common.like(param[0], param[1], parent_block);
		
		return false;
	});
	
    /**
     * ! Событие
     * Открытие попапа 
     */
    $('.content-item').live('click', function(e) {
			if (!$(e.target).closest('.item-info').length) {
        id = $(this).parents('.content-item').attr('data-item-id');
        type = $(this).parents('.content-item').attr('data-item-type');
				console.log(id,type);
        controller = $('body').attr('data-controller');
        
				$('#search_smart').hide();
				
				popup.open(id, type, controller);
        
        return false;
			}
    });
    
    /**
     * ! Событие
     * Открытие формы обратной связи 
     */
    $('.fb-add a').live('click', function()
    {
    	var popup_block = $(this).parents('.popup-slider');
    	popup.showFeedbackForm(popup_block);
    	return false;
    });
    
    /**
     * ! Событие
     * Открытие формы обратной связи 
     */
    $('.fb-close').live('click', function()
    {
    	var popup_block = $(this).parents('.popup-slider');
    	popup.hideFeedbackForm(popup_block);
    	return false;
    });
    
	$('.fb-full-text').live('click', function() //view-full-text
	{
		popup.viewHideFullText($(this).parents('.popup-fb-cont-text'));
		return false;
	});
	
	$('.view-full-text').live('click', function() //view-full-text
	{
		popup.viewHideFullTextCommon($(this).parents('.popup-texts'));
		return false;
	});
    
    $('#feddbackSend').live('click', function()
    {
    	popup.sendFeedback();
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
		popup.close();
        return false;
    });
    
    /**
     * Открытие блока "Предложить работу" на странице списка резюме 
     */
	$('.item-order-job-button').live('click', function()
	{
		var item = $(this).parents('.simple-content-item');
		var block = $('.item-order-job', item);
		
		if(block.css('display') == 'none')
			block.css('display', 'block');
		else
			block.css('display', 'none');
		
		return false;
	});
	/**
	 * Закрытие блока 
	 */
	$('.campaign-send-buttons-r').live('click', function()
	{
		$(this).parents('.item-order-job').css('display', 'none');
		return false;
	});
    
    /**
     * Вкладки на главной 
     */
	var main_zindex = 100;
	
	
	$('.new-other-tabs li').each(function()
    {
        $(this).css('z-index', main_zindex);
        main_zindex--;
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
	 * Открытие блока с полем E-mail для отправки АКЦИИ 
	 */
	$('#viewSendCampaign').live('click', function()
	{
		var block = $('#campaignSend');
		
		if(block.css('display') == 'none')
			block.css('display', 'block')
		else
			block.css('display', 'none')
			
		return false;
	});
	$('.campaign-send-buttons-r').live('click', function()
	{
		$(this).parents('.campaign-send').css('display', 'none');
		return false;
	});
	
	/**
	 * Открытие блока с списком резюме для отправки на странице ВАКАНСИИ
	 */
	$('#viewSendResume').live('click', function()
	{
		var block = $('#sendResume');
		
		if(block.css('display') == 'none')
		{
			block.css('display', 'block');
			jQuery('.list-resume-scroll-pane').jScrollPane({trackClickSpeed:40});
		}
		else
			block.css('display', 'none');
			
		return false;
	});
	$('.list-resume-buttons-r').live('click', function()
	{
		$(this).parents('.job-list-resume').css('display', 'none');
		return false;
	});
	
	/**
	 * Переключение блоков из желтой навигации 
	 */
	$('.entity-nav-but').live('click', function()
	{
		var block = $(this).attr('data-block');
		$('.entity-content-block').css('display', 'none');
		
		$('.entity-content-block[data-block="'+block+'"]').css('display', 'block');
		
		return false;
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
    	
    	if($('.popup-slider').css('display') == 'none' || $('.popup-slider').length < 1)
    	{
    		$('#mask').hide();
    	}
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
			if  ($(this).attr('href') !== "#") return true;
    	if($('ul', $(this).closest('li')).css('display') == 'none')
        {
        	$('.' + $(this).closest('li').attr('class') + ' ul').hide(200);
					$('.' + $(this).closest('li').attr('class') + ' a').removeClass('active');
        	
        	
            $('ul', $(this).closest('li')).show(200);
            $('ul li ul', $(this).closest('li')).css('display', 'none');
        }
        else
        {
            $('ul', $(this).closest('li')).hide(200);
        }
        
        if($(this).attr('data-transition') == 'true')
        {
        	return true;
        }
        else {
					$(this).toggleClass('active');
					return false;
				};
    });
    
    //Открытие остальных категорий
	$('.sub-nav-more-view').live('click', function()
	{
		var block = $('.sub-nav-more[data-nav="'+$(this).attr('data-nav')+'"]')
		
		if(block.css('display') == 'none')
		{
			block.slideDown(200);
			$(this).text('Скрыть');
		}
		else
		{
			block.slideUp(200);
			$(this).text('Показать все категории');
		}
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
    declareCarousel($('#cont_slider_5'), '#cont_slider_prev_5', '#cont_slider_next_5');
    
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
     * ВНИМАНИЕ!!! Размер картинки - WIDTH:700, HEIGHT:190
     * 
     */
    $('#bannerSlider ul li').css('width', 700 + 'px');
    $('#bannerSlider ul li').css('height', 190 + 'px');
    
    
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
                      'margin' : '-1px 20px -1px -20px',
                      'text-align': 'left',
                      'background': '#52dbfd',
                      'border': '1px solid #cccccc',
                      'padding': '11px 0px 10px 20px'
                  }, 250).addClass('banner-but-active');
                  
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
                      'padding': '11px 0px 10px 20px'
                      
                  }, 250).removeClass('banner-but-active');
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
						$('#search_smart').hide();
            block.slideDown(300);
            $('img', $(this)).attr('src', dir_images + 'hide-search.png');
						$(".selectbox", block).selectbox({animationSpeed:50});
						$('#search_ext .search-category-select').on('change',function(){
							var cat = $(this).find(':selected').val(),
									container = $('#search_ext'),
									ch_free = $('[name="with_free_delivery"]',container).parents('label'),
									ch_campaign = $('[name="with_campaign"]',container).parents('label'),
									bl_price = $('.search-price',container),
									lb_filter = $('.filter-label',bl_price).first();
							switch (cat) {
								case 'goods':
										ch_free.show();
										ch_campaign.show();
										bl_price.show();
										lb_filter.html('Цена');
									break;
								case 'services':
										ch_free.hide();
										ch_campaign.show();
										bl_price.show();
										lb_filter.html('Цена');
									break;
								case 'reviews':
									ch_free.hide();
									bl_price.hide();
									ch_campaign.hide();
									break;
								case 'campaings':
									ch_free.hide();
									bl_price.hide();
									ch_campaign.hide();
									break;
								case 'jobs':
										ch_free.hide();
										ch_campaign.hide();
										bl_price.show();
										lb_filter.html('Зарплата');
									break;
								case 'companies':
										ch_free.hide();
										bl_price.hide();
										ch_campaign.hide();
									break;
							}
						});
								
        }
        else
        {
            block.slideUp(300);
            $('img', $(this)).attr('src', dir_images + 'view-search.png');
        }
        return false;
    });
		
		// фильтры расширенного поиска
		
		if($('#search_ext_price').length > 0)
		{
			var from = (get_param('price_from')) ? get_param('price_from') : 0;
			var to = (get_param('price_to')) ? get_param('price_to') : max_num;
			
			UISlider("#search_ext_price", "input#ext_price_from", "input#ext_price_to", 0, max_num, from, to, '');
			

		}
		

			
			
		// отображение выпадающего списка результатов поиска
		// TMP demo code - replace by ajax
		$('#search_inp').keyup(function(){
			if ($.trim($(this).val()) != '') {
			  $('#search_ext').hide();
				$('#search_field').addClass('active').find('.search-clear-cross').show();
				$('img', $('#search_ext_view')).attr('src', dir_images + 'view-search.png');
			  $('#search_smart').show();
			  jQuery('.search-smart').jScrollPane();
			} else {
				 $('#search_smart').hide();
				 $('#search_field').removeClass('active').find('.search-clear-cross').hide();
			}
		});
		
		$('#search_inp').focus(function(){
			$("html,body").animate({scrollTop:$('#search').offset().top})
		})
		
		$('#search_field .search-clear-cross').click(function(){
			$('#search_inp').val('');
			$('#search_field').removeClass('active').find('.search-clear-cross').hide();
			$('#search_inp').focus();
		})
		
		/*
		 * Показ подкатегорий на странице категорий товаров/услуг
		 */
		$('.cis-show').click(function(){
			$(this).closest('.category-item').find('.category-item-subcat').toggleClass('opened');
			})
		
		
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
    $(".form select, .selectbox").selectbox({speed:50});

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
    
    if(jQuery('.list-resume-scroll-pane').length > 0)
    {
    	jQuery('.list-resume-scroll-pane').jScrollPane({trackClickSpeed:40});
    }
		
		/**
     * Открытие формы комментирования 
		 */
		
		$('.show-comment-add').live('click',function(e){
			$(this).closest('#comments').find('.comment-add').toggle();
			e.preventDefault();
		});
		
		/**
     * Отображение блока "Рассылка"
     */
    $('.subscribe .view').live('click', function(){
        
        var items = $('ul', $(this).closest('.subscribe'));
        
        if(items.css('display') == 'none')
            items.show(50);
        else
            items.hide(50);
        return false;
    });
    // Скрытие вышеописанного блока
    $(document).click(function(event){
        if ($(event.target).closest(".subscribe").length) return;
        $('.subscribe ul').hide(50);
        event.stopPropagation();
    });
		
		/**
		 * Сокрытие элементов
		 */
		
		$('[data-role="hide"]').click(function(){
			$(this).closest('.hiddable').fadeOut('fast');
			$('#mask').hide();
		});
		
		$('.ca-banner18-btn[data-role="blink"]').click(function(){
			var txt_bl = 	$(this).closest('.ca-banner18').find('.ca-banner18-txt');
			txt_bl.addClass('blink');
			setTimeout(function(){txt_bl.removeClass('blink');}, 800);
		});
		
		/* Демо-подсказки в поиске */
		
		NB.search_tips = [];
		NB.tips_active = 1;
		$('.menu-level-3 a, .menu-level-4 a').each(function(){
			var cat_name = $(this).text().split(','),
					i;
			for (i = 0; i < cat_name.length; i++) {
				var cat_item = $.trim(cat_name[i].match(/[A-Za-zА-Яа-яЁё0-9_\s]+/i)[0]);
				NB.search_tips.push(cat_item.substr(0, 1).toUpperCase() + cat_item.substr(1));
			}
		});
		
		makeSearchTips(NB.search_tips);
		
		function makeSearchTips(arr) {
			if ((!arr.length) || (!NB.tips_active)) return false;
			var n = Math.floor(Math.random() * arr.length);
			showSearchTips(arr[n]);
		}
		
		function showSearchTips(str) {
			var inp_el = $('#search_inp'),
					len = str.length,
					cur_n = 0;
			NB.search_timer = setInterval(function(){
				if (cur_n < len) {
					inp_el.val(inp_el.val() + str.charAt(cur_n));
					cur_n++;
				} else {
					clearInterval(NB.search_timer);
					setTimeout(function(){
						inp_el.val('');
						makeSearchTips(NB.search_tips);
					}, 1000)
				}
			}, 200)
		}
		
		$('#search_inp').focus(function(){
			if (NB.search_timer) {
				clearInterval(NB.search_timer);
			}
			if (NB.tips_active) {
				$(this).val('');
			}
			NB.tips_active = 0;
		})
		
		$('#search_inp').blur(function(){
			if ($(this).val() == '') {
				NB.tips_active = 1;
			}
			makeSearchTips(NB.search_tips);
		});
		
		/* скрытие панелей поиска */
		$(document).click(function(e){
			if (!$(e.target).closest('#search_smart').length) $('#search_smart').hide();
		})
		
		// инициализация вкладок /* TODO: away from 'popup' namespace*/
		popup.tabs()
		
		// показ кнопки результатов - TODO: перенести на ajax:success отправки формы
		$('input, select', '.filters').change(function(){
			$('.found-res ').slideDown('fast')
		});
		$('.polzunok').mouseup(function(){
			$('.found-res ').slideDown('fast')
		})
		
		// подгрузка содержимого по кнопке ПОКАЗАТЬ ЕЩЕ N
		$('.pagination-link').live('click', function(e){
			var new_separator = $('.pagination-separator:last').clone();
			var page_num = new_separator.find('.ps-page-num')
			page_num.data('page',parseInt(page_num.data('page')) + 1).attr('data-page', parseInt(page_num.data('page')));
			page_num.html(page_num.data('page'));
			$(this).before(new_separator);
			new_separator.show();
			$(this).before(
				$('.content-item:lt(10)').clone() // TODO: replace with ajax .load() instead of demo with clone
			); 
			e.preventDefault();
		})

		/* Кнопка Наверх */
		$(document).scroll(function(){
			if ($(document).scrollTop() >= $('#slider').offset().top) {
				$('#btn_goto_top').fadeIn('fast');
			} else {
				$('#btn_goto_top').fadeOut('fast');
			}
		})
		
		$(window).resize(function(){
			$('#btn_goto_top').css('width', $('#container').offset().left + 'px');
		})
			
		$('#btn_goto_top').click(function(e) {
			$('html, body').animate({ scrollTop: 0 }, 'fast');
			e.preventDefault();
		}).css('width', $('#container').offset().left + 'px');
		
		
		/**
     * Отображение и скрытие панели НаОбзоре
     */
		var DIR_IMAGES = '/miniSite/images/'
		function toggleTopPanel(action) {
			var block = $('#topPanel header');
			var panel = $('#controlTopPanel');
    
        if (block.css('display') == 'block')
        {
            block.hide();
            panel.text('Раскрыть');
            panel.css('background', 'url(' + DIR_IMAGES + 'top-view.png) left center no-repeat');
            panel.closest('footer').css('margin-top','12px').find('.footer-menu').removeClass('hidden');
        }
        else if (action !== 'hide')
        {
            block.show();
            panel.text('Свернуть');
            panel.css('background', 'url(' + DIR_IMAGES + 'top-hide.png) left center no-repeat');
            panel.closest('footer').css('margin-top','74px').find('.footer-menu').addClass('hidden');
        }
        return false;
		}
			
    $('#controlTopPanel').live('click', function(e){
			toggleTopPanel();
			e.preventDefault();
    });
				
		/* Показ/Скрытие подменю категорий поиска */
		$('#topPanel .search-submenu').hide();
		$('#topPanel .show-search-submenu').click(function(){
			$(this).siblings('.search-submenu').slideToggle('fast');
			$(this).toggleClass('hide');
		});
		
		if (!NB) NB = {}
		NB.goal_opened_pos = 400;
		NB.top_panel_h = 84;
		$('#topPanel').css('margin-top', '-' + NB.top_panel_h + 'px')
		$(document).scroll(function(){
			var cur_pos = $(document).scrollTop() - $('#search').offset().top;
			$('#topPanel').stop(true, true);
			if (cur_pos >= 0) {
				if (parseInt($('#topPanel').css('margin-top')) >= 0) return;
				var new_pos = - NB.top_panel_h  * (NB.goal_opened_pos - cur_pos) / NB.goal_opened_pos;
				$('#topPanel').animate({'margin-top': new_pos + 'px'}, 200,
																function(){
																	if (parseInt($('#topPanel').css('margin-top')) > 0)	{
																		$('#topPanel').css({'margin-top': 0})
																	}
																})
			} else {
				$('#topPanel').animate({'margin-top': '-' + NB.top_panel_h + 'px'},200)
			}
		});
		
		$('#topPanel').mouseenter(function(){
			$('#topPanel').stop(true, true);
				$('#topPanel').css({'margin-top': 0})
		})	

				
		/* универсальный крестик закрытия */
		
		$('[data-role="close"]').click(function(){
			$(this).closest('[data-role="closeable"]').hide();
			$('[data-role="closeable-mask"]').hide();
		})
		
		/* */
		$('#sendResumeLink').click(function(){
			$('#sendResumeBlock').toggleClass('hidden');
			return false;
		})
		
    

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

/**
 * Ползунок для создания элемента управления для выбора диапазона чисел
 * @ID - айдишник блока в который будет размещатся ползунок
 * @input_0 - Текстовое поле которое хранит в себе начало
 * @input_1 - Текстовое поле которое храние в себе конец
 * @min - Минимальное значение
 * @max - Максимальное значение
 * @from - Установка значения начала
 * @to - Установка значения конца
 * @callback - Имя функции которую надо вызвать после выбора диапазона
 */
function UISlider(ID, input_0, input_1, min, max, from, to, callback)
{
	jQuery(ID).slider({
		min: min,
		max: max,
		values: [from, to],
		range: true,
		stop: function(event, ui) {
			jQuery(input_0).val(jQuery(ID).slider("values", 0));
			jQuery(input_1).val(jQuery(ID).slider("values", 1));
			
			if(callback) window[callback]();
	    },
	    slide: function(event, ui){
			jQuery(input_0).val(jQuery(ID).slider("values", 0));
			jQuery(input_1).val(jQuery(ID).slider("values", 1));
	    }
	});
	
	jQuery(input_0).change(function(){
	
		var value1=jQuery(input_0).val();
		var value2=jQuery(input_1).val();
	
	    if(parseInt(value1) > parseInt(value2)){
			value1 = value2;
			jQuery(input_0).val(value1);
		}
		jQuery(ID).slider("values", 0,value1);	
	});

	jQuery(ID).change(function(){
			
		var value1=jQuery(input_0).val();
		var value2=jQuery(input_1).val();
		
		if (value2 > max) { value2 = max; jQuery(input_1).val(max)}
	
		if(parseInt(value1) > parseInt(value2)){
			value2 = value1;
			jQuery(input_1).val(value2);
		}
		jQuery(ID).slider("values", 1, value2);
	});

	// фильтрация ввода в поля
	jQuery(input_1 + ', ' + input_0).keypress(function(event){
		var key, keyChar;
		if(!event) var event = window.event;
		
		if (event.keyCode) key = event.keyCode;
		else if(event.which) key = event.which;
	
		if(key==null || key==0 || key==8 || key==13 || key==9 || key==46 || key==37 || key==39 ) return true;
		keyChar=String.fromCharCode(key);
		
		if(!/\d/.test(keyChar))	return false;
	});
}

/**
 * Фильтрация контента 
 */
function filter()
{
	var url = window.location.search.substr(1).split("&");
	var category = ($('#currentCategory').length > 0 && $('#currentCategory').attr('data-value') != 0) ? '/' + $('#currentCategory').attr('data-value') + '/' : '';
	var param = {};
	var result = '/' + $('body').attr('data-controller') + category + '?';
	
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
			result += p + '=' + param[p] + '&';
	}
	
	result = result.substring(0, result.length - 1)

	location.href = location.protocol + "//" + location.hostname + ":" + location.port + result;
}

/**
 * Получение значения параметра
 * @param {string} name - название параметра
 */
function get_param(name)
{
	var url = window.location.search.substr(1).split("&");
	var param = {};
	result = false;
	
	for(var i = 0; i < url.length; i++)
	{
		var tmp = url[i].split('=');
		param[tmp[0]] = tmp[1];
		if(tmp[0] == name) result = tmp[1];
	}
	return result;
}


function var_dump(arr,level) {
  var dumped_text = "";
  if(!level) level = 0;

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

/* Alerts */
function showAlert(message){
	if (message) {
		var alert_window = $('<div class="alert">' + message + '</div>');
		setTimeout(function(){
			alert_window.animate({opacity: 0}, 1500, function(){$(this).remove();})
		}, 2000);
		$(document.body).append(alert_window);
	}
}
