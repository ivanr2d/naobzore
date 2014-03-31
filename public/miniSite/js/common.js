jQuery(document).ready(function($){

    var DIR_IMAGES = 'images/'

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
		if($('.selectbox').length > 0) $('.selectbox').selectbox({animationSpeed: 50}).bind('change', function(){
       	alert($(this).val());
    });
		
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
    $('#controlTopPanel').live('click', function(){
    
        var block = $('#topPanel header');
    
        if(block.css('display') == 'block')
        {
            block.hide();
            $(this).text('Раскрыть');
            $(this).css('background', 'url(' + DIR_IMAGES + 'top-view.png) left center no-repeat');
            $(this).closest('footer').css('margin-top','13px').find('.footer-menu').removeClass('hidden');
        }
        else
        {
            block.show();
            $(this).text('Свернуть');
            $(this).css('background', 'url(' + DIR_IMAGES + 'top-hide.png) left center no-repeat');
            $(this).closest('footer').css('margin-top','74px').find('.footer-menu').addClass('hidden');
        }
        return false;
    });
    $('#controlTopPanel').click();
		
		/* поиск по иконке */
		$('#topPanel .icon-lupa').click(function(){
			$('#topPanel .search [type="submit"]').click();
		});
		
		
    /**
     * Управление категориями в левом блоке
     */
    $('.categories a').live('click', function(){
        
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
     * Отображение блока "Отправить резюме"
     */
    $('#sendResume').live('click', function(){
        if($('#sendResumeBlock').css('display') == 'none')
        {
            $('#sendResumeBlock').show();
            jQuery('.scrollpane').jScrollPane({trackClickSpeed:40});
        }
        else
            $('#sendResumeBlock').hide();
        return false;
    });
    // Скрытие вышеописанного блока
    $(document).click(function(event){
        if ($(event.target).closest(".send-resume").length) return;
        $('.send-resume').hide();
        event.stopPropagation();
    });
    // Еще одно скрытие вышеописанного блока
    $('.send-resume .cancel').live('click', function(){
        $(this).closest(".send-resume").hide();
        return false;
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
		$('.show-comments').click(function(e){		
			var item = $(this).closest('[data-id]');
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
    $('#sendCampaign').live('click', function(){
        if($('#sendCampaignBlock').css('display') == 'none')
        {
            $('#sendCampaignBlock').show();
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
    $('.view, .hide, .tit ', '.feedback .text').live('click', function(){
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
    if(jQuery("#cost").length) jQuery("#cost").slider({
        min: 0,
        max: 1000,
        values: [0,1000],
        range: true,
        stop: function(event, ui) {
            jQuery("input#minCost").val(jQuery("#cost").slider("values",0));
            jQuery("input#maxCost").val(jQuery("#cost").slider("values",1));
        },
        slide: function(event, ui){
            jQuery("input#minCost").val(jQuery("#cost").slider("values",0));
            jQuery("input#maxCost").val(jQuery("#cost").slider("values",1));
        }
    });

    
/**
     * Открытие поапа с характеристиками
     */
    var popupDescription;
    
    $('.view-popup[data-type="send-message"]').live('click', function(){
        popupDescription = new Popup('send-message', $(this).text(), $(this));
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