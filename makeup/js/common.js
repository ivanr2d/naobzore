jQuery(document).ready(function($){


    /**
     * Используется:
     *   1. Для стрелки кнопки расширенного поиска
     */
    var dir_images = 'img/';
    

        
    /**
     * Отображение/скрытие категорий или подкатегори в правом блоке
     */
    $('#sub_nav ul li a').live('click', function()
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
        return false;
    });
    
    
    /**
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
    
    $('#slider_goods .sub-cont:not(:first)').css('display', 'none');
    $('#pop_companys .sub-cont:not(:first)').css('display', 'none');
    
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
    $('#about_slider_slides').jCarouselLite({
        btnGo: ["#btn_1", "#btn_2", "#btn_3", "#btn_4"],
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
    /*
     * Слайдер баннеров на второстепенных страницах
     * 
     * ВНИМАНИЕ!!! Размер картинки - WIDTH:595, HEIGHT:188
     * 
     */
    $('#bannerSlider ul li').css('width', 595 + 'px');
    $('#bannerSlider ul li').css('height', 188 + 'px');
    
    $('#bannerSlider').jCarouselLite({
        btnGo: ["#sl_1", "#sl_2", "#sl_3", "#sl_4", "#sl_5"],
        visible: 1,
        speed: 500,
        auto: 10000,
        circular: true,
        vertical: false,
        hoverPause: true,
        start: 2,
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
    
    $('#slider, #left, #content, #search, #header_main, #main_nav, #last_footer, #header_righ').click(function(e)
    {
        $('#registration').css('display','none');
        $('#login').css('display','none');
        $('#add').css('display','none');
        
        clearTab();
    });

    /**
     * Всплывающий большой блок (расширеный обзор сущности)
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
    
    $('.item-title a').live('click', function()
    {
        id = $(this).attr('data-item-id');
        $('.popup-slider').css('display','block');
        $('#mask').css('display','block');
        return false;
    });
    $('.popup-close a').live('click', function()
    {
        $(this).parent().parent().parent().css('display', 'none');
        $('#mask').css('display','none');
        return false;
    });
    
    /**
     * Востановление пароля
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
    
    $('.item-image a').live('click', function()
    {
        id = $(this).attr('data-item-id');
        $('.popup-slider').css('display','block');
        $('#mask').css('display','block');
        return false;
    });
    $('.item-text').live('click', function()
    {
        id = $(this).attr('data-item-id');
        $('.popup-slider').css('display','block');
        $('#mask').css('display','block');
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
    $(" .form select").selectbox();

    $("#area").selectbox().bind('change', function(){
        ////!!!!Пишем код при смене значения
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
            $(this).attr('src', 'img/list-item-open.png');
        }
        else
        {
            $('ul', li).css('display', 'none');
            $(this).attr('src', 'img/list-item-close.png');
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
            imageLoading: 'img/lightbox-btn-loading.gif',
            imageBtnClose: 'img/lightbox-btn-close.gif',
            imageBtnPrev: 'img/lightbox-btn-prev.gif',
            imageBtnNext: 'img/lightbox-btn-next.gif',
            containerResizeSpeed: 350,
            txtImage: 'Изображение',
            txtOf: 'из'
        });
    }
        
        
    /**
     * Открытие/скрытие пунктов меню на странице юзера
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
    
    //jQuery('.list-resume-scroll-pane').jScrollPane({trackClickSpeed:40});
    
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

});

function declareCarousel(obj, prev, next)
{
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