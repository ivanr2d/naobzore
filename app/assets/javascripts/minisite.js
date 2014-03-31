jQuery(document).ready(function($){

    var DIR_IMAGES = '/miniSite/images/'

    /**
     * Отображение остальных пунктов меню в панели НаОбзоре а так же скрытие
     */
    $('#viewMenuItems').live('click', function(){

        var menu = $('#hiddenMenuItems');
        
        if(menu.hasClass('hidden'))
        {
            menu.removeClass('hidden');
            $('img', $(this)).attr('src', DIR_IMAGES + 'icon-hide.png');
        }
        else
        {
            menu.addClass('hidden');
            $('img', $(this)).attr('src', DIR_IMAGES + 'icon-view.png');
        }
        return false;
    });
    
		/* Селекты фильтров */
		if($('.selectbox').length > 0) { 
			$('.selectbox').selectbox({animationSpeed: 50}).bind('change', function() {
				$(this).parents('form').submit();
			});
		}
	
		/* Универсальный плейсхолдер */
		(function(){
			var holders = [];
			$('.holder').each(function(i){
				holders.push($('.holder').val());
				$(this).focus(function(){
					if (holders[i] === $(this).val()) {
						 $(this).val('');
					}
				}).blur(function(){
					if ($(this).val() == '') {
						 $(this).val(holders[i]);
					}
				})
			});
		})();
    
    
    /**
     * Отображение и скрытие панели НаОбзоре
     */
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
		toggleTopPanel();
		
		$(document).click(function(e){
			if (!$(e.target).closest('#topPanel').length) {
				toggleTopPanel('hide');
				$('#login, #registration').hide();
				e.stopPropagation();
			}
		});
    
    
    /**
     * Управление категориями в левом блоке
     */
    $('.categories a[href="#"]').live('click', function(){
        
    	if($('ul', $(this).closest('li')).css('display') == 'none')
        {
        	$('ul', $(this).closest('ul')).hide(100);
        	$('a', $(this).closest('ul')).removeClass('active');
            
            $('ul', $(this).closest('li')).show(100);
            $('ul li ul', $(this).closest('li')).css('display', 'none');
            
            $(this).addClass('active');
        }
        else
        {
            $('ul', $(this).closest('li')).hide(100);
            $(this).removeClass('active');
        }
        if($(this).attr('data-transition') == 'true')
        {
        	return true;
        }
        return false;
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
     * Переключение между "Описанием" и "Комментариями" на странице вакансии и т.д
     */
    $('#viewDescription').live('click', function(){
        $('#descriptionBlock').show();
        $('#commentsBlock').hide();
        $('#sendResumeBlock').hide();
        return false;
    });
    $('#viewComments').live('click', function(){
        $('#commentsBlock').show();
        $('#descriptionBlock').hide();
        $('#sendResumeBlock').hide();
        return false;
    });
    
    
    
    /**
     * Переключение вкладок на странице "Товр", "Услуга"
     */
    $('.tabs .tabs-items li a').live('click', function(){
        
        var tab = $(this).attr('data-tab');
        
        if(tab == 'popup') return false;
        
        $('.tabs .tabs-items li a').removeClass('active');
        $(this).addClass('active');
        
        $('.tab-content', $(this).closest('.tabs')).addClass('hidden');
        $('.tab-content[data-tab="' + tab + '"]', $(this).closest('.tabs')).removeClass('hidden');
        
        if($('.send-campaign').length) $('.send-campaign').hide();
        
        return false;
    });
    
    	/* Показ комментариев */
		$('.show-comments').live('click', function(e){		
			var item = $(this).closest('.campaign');
			$(this).toggleClass('active');
			if ($(this).hasClass('active')) {
				if ($(item).has('.comments').length === 0) {  // загрузить комментарии
					/* ajax comments loading */
						//tmp code
						var comments = $('#commentsBlock').clone();
					/* end ajax comments loading */
					$(item).find('.footer').after(comments);
				}
				$(item).find('.comments').slideDown();
			}	else {
				$(item).find('.comments').slideUp();
			}
			e.preventDefault();
		});
		
		$('.show-comment-add').live('click',function(e){
			$(this).closest('.comments').find('.add').toggle();
			e.preventDefault();
		});
		
		/**
     * Блок отправки "Акции"
     */
    $('#sendCampaign').click(function(){
        if($('#sendCampaignBlock').css('display') == 'none')
        {
            $('#sendCampaignBlock').toggle();
        }
        else
            $('#sendCampaignBlock').hide();
        return false;
    });
    // Скрытие вышеописанного блока
		$(document).click(function(event){
        if ($(event.target).closest(".send-campaign").length) return;
        $('.send-campaign').hide();
        event.stopPropagation();
    });
    // Еще одно скрытие вышеописанного блока
    $('.send-campaign .cancel').live('click', function(){
        $(this).closest(".send-campaign").hide();
        return false;
    });  
    
    /**
     * Отображение скрытие отзыва
     */
    $('.view, .hide, .tit ', '.feedback .text').click(function(){
        var feedback = $(this).closest('.feedback');
        $('.text.mini', feedback).toggleClass('hidden');
        $('.text.full', feedback).toggleClass('hidden');
        return false;
    });
		
    
		/* Показ/Скрытие подменю категорий поиска */
		$('#topPanel .search-submenu').hide();
		$('#topPanel .show-search-submenu').click(function(){
			$(this).siblings('.search-submenu').slideToggle('fast');
			$(this).toggleClass('hide');
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
            
            $('.review-title a', review).addClass('active');
        }
        else
        {
            $('.detail-full', review).css('display', 'none');
            $('.detail-mini', review).css('display', 'block');
            $('.review-other', review).css('display', 'none');
            
            $('.review-title a', review).removeClass('active');
        }
        
        return false;
    });
		
		/* страница результатов поиска */
		$('.search-res-cats .src-link').live('click', function(e){
			$(this).siblings('.active').removeClass('active');
			$(this).addClass('active');
			$(this).closest('.search-res-cats').find('.src-corner').css({
				'left': $(this).position().left + parseInt($(this).css('margin-left')) + 'px'
			});
			$('.search-res-items[data-search-res]').hide().filter('[data-search-res=' + $(this).data('search-tab') + ']').show();
			$('.selectbox').selectbox({animationSpeed: 50}).bind('change', function() {
				$(this).parents('form').submit();
			});
			initSliders ();
			e.preventDefault();
		})
    
    
		$('.tab-content[data-tab="4"] .tit a').click(function(e){
			$(this).closest('.data').toggleClass('data-opened');
			e.preventDefault();
		})
    
    /*----------------------------------------------------------*
     | Приминение плагинов                                      |
     *---------------------------------------------------------*/
    
    
    /**
     * Фотогалерея
     */
    if($('.lightbox').length) jQuery(".lightbox a").lightBox({
        overlayOpacity: 0.7,
        imageLoading:  DIR_IMAGES + 'lightbox-btn-loading.gif',
        imageBtnClose: DIR_IMAGES + 'lightbox-btn-close.gif',
        imageBtnPrev:  DIR_IMAGES + 'lightbox-btn-prev.gif',
        imageBtnNext:  DIR_IMAGES + 'lightbox-btn-next.gif',
        containerResizeSpeed: 350,
        txtImage: 'Изображение',
        txtOf: 'из'
    });
    
    
    /**
     * Слайдер цены товаров
     */
		function initSliders () {
			if(jQuery("[id=cost]").length) jQuery("[id=cost]").slider({
					min: $('[id=minCost]').val()*1,
					max: $('[id=maxCost]').val()*1,
					values: [$('[id=minCost]').val()*1, $('[id=maxCost]').val()*1],
					range: true,
					stop: function(event, ui) {
							jQuery("input[id=minCost]").val(jQuery("[id=cost]").slider("values",0));
							jQuery("input[id=maxCost]").val(jQuery("[id=cost]").slider("values",1));
							$(this).parents('form').submit();
					},
					slide: function(event, ui){
							jQuery("input[id=minCost]").val(jQuery("[id=cost]").slider("values",0));
							jQuery("input[id=maxCost]").val(jQuery("[id=cost]").slider("values",1));
					}
			});
		}
		initSliders ();

    $('#with_campaign').live('change',function() {
			var form =  $(this).parents('form');
			$.get(form.attr('action'), form.serialize(), function(data) {
					initSliders ();
			});
    });

    $('.subscribe form').on('ajax:complete', function() {
      // XXX зачем ?
			initSliders ();
    });

    $('.subscribe :checkbox').live('change',function() {
      $(this).closest('form').submit();
    });

    
/**
     * Открытие поапа с характеристиками
     */
    var popupDescription;
    
    $('.view-popup[data-type="send-message"]').live('click', function(){
        $('#message_mtype').val($(this).data('mtype'));
        $('#message_to_id').val($(this).data('to_id'));
        popupDescription = new Popup($(this).data('type'), $(this).text(), $(this));
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

  $('.pagination[data-replace_id] a[data-remote]').live('ajax:complete', function(event, data) {
    $('#' + $(this).parents('.pagination').data('replace_id')).html(data.responseText);
  });

  /* Взято с осн страниц для логина/регистрации */
    /**
     * Отображение блока регистрации
     */
    $('#view_registration, .view-registration').live('click', function()
    {
        var block = $('#registration');
				if ($('#topPanel header').is(':visible')) {
					block.addClass('with-header-opened');
				} else {
					block.removeClass('with-header-opened');
				}
    
        if(block.css('display') == 'none')
        {
            block.css('display','block');
        }
        else
        {
            block.css('display','none');
        }
        
        $('#login').css('display', 'none');
        $('#add').css('display', 'none');
        
        return false;
    });
    
    /**
     * Отображение блока входа
     */    
    $('#view_login, .view-login').on('click', function()
    {
        var block = $('#login');
				if ($('#topPanel header').is(':visible')) {
					block.addClass('with-header-opened');
				} else {
					block.removeClass('with-header-opened');
				}
				
    
        if(block.css('display') == 'none')
        {
            block.css('display','block');
        }
        else
        {
            block.css('display','none');
					return false;
        }
        
        $('#registration').css('display', 'none');
        $('#add').css('display', 'none');
        
        return false;
    });
   

  $('.likes a.like').live('ajax:complete', function(event, data) {
    $(this).closest('.likes').find('.likes_count').text(data.responseText);
		$(this).toggleClass('actived');
  });

  $('.likes a.ignore').on('ajax:complete', function(event, data) {
    $(this).closest('.item', '.items').remove();
    $(this).closest('.campaign', '.campaigns').remove();
		$(this).addClass('actived');
		showAlert("Добавлено в&nbsp;черный список.");
    if ($(this).data('redirect')) {
      document.location.pathname = $(this).data('redirect');
		}
  });

  $('.likes a.favorite').live('ajax:complete', function(event, data) {
		if (!$(this).is('.actived')) {
			showAlert("Добавлено в&nbsp;личный кабинет!");
		} else {
			showAlert("Удалено из&nbsp;личного кабинета.");
		}
		$(this).toggleClass('actived');
  });
	
	// показ кнопки результатов - TODO: перенести на ajax:success отправки формы
	$('input, select', '.filters').change(function(){
		$('.found-res ').slideDown('fast')
	});
	$('.ui-slider-horizontal').mouseup(function(){
		$('.found-res ').slideDown('fast')
	});
	
	// подгрузка содержимого по кнопке ПОКАЗАТЬ ЕЩЕ N
	$('.pagination-link').live('click', function(e){
		var new_separator = $('.pagination-separator:last').clone();
		var page_num = new_separator.find('.ps-page-num')
		page_num.data('page',parseInt(page_num.data('page')) + 1).attr('data-page', parseInt(page_num.data('page')));
		page_num.html(page_num.data('page'));
		$(this).before(new_separator);
		new_separator.show();
		$(this).before(
			$('.jobs-items:lt(10), jobs-items:lt(10), .items .item:lt(10)').clone() // TODO: replace with ajax .load() instead of demo with clone
		); 
		e.preventDefault();
	})
});

/**
 * @param string type - Тип
 * @param mixed data - Данные попапу
 * @param JQuery object caused - Объект вызвавший попап
 */
function Popup(type, data, caused)
{
    this._popup = $('.popup[data-type="' + type + '"]');
    
    this._width = this._popup.outerWidth();
    this._height = this._popup.outerHeight();
    this._title = this._popup.find('header .title').text();
    
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
        if (this.getCaused().data('title')) {
          this._popup.find('header .title').text(this.getCaused().data('title'));
        }
        
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
        this._popup.find('header .title').text(this._title);
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
