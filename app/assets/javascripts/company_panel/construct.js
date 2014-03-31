$(function() {
  $('.picker input').minicolors({
    inline: true,
    change: function(){
      var picker = $(this).closest('.picker');
      var input = $('minicolors-input', picker)
      $('.result', picker).css('background', this.value);
      picker.closest('form').submit()
    }
  });

  // XXX лучше всем проставить класс чем перечислять
  // файлы
  $('#site_tmp_header_image_background, #site_tmp_external_image_background, #site_favicon, #site_tmp_header_logotype').change(function() {
    $(this).closest('form').submit();
  });
  
  // селекты
  $('[data-setting=footer_font] li, [data-setting=info_content_font] li, [data-setting=info_title_font] li, [data-setting=menu_text_font_family] li, [data-setting=text_content_font] li, [data-setting=text_title_font_family] li').click(function() {
    $('#site_tmp_' + $(this).parent().data('setting')).val($(this).text());
    $(this).closest('form').submit();
  });

  // чекбоксы
  $('[data-setting=footer_weight], [data-setting=footer_style], [data-setting=info_content_weight], [data-setting=info_content_style], [data-setting=info_title_weight], [data-setting=info_title_style], [data-setting=menu_text_font_weight], [data-setting=menu_text_font_style], [data-setting=text_content_weight], [data-setting=text_content_style], [data-setting=text_title_font_weight], [data-setting=text_title_font_style]').click(function() {
    $('#site_tmp_' + $(this).data('setting')).val($(this).find(':checkbox').attr('checked') ? $(this).data('cv') : $(this).data('ucv'));
    $(this).closest('form').submit();
  });

  // видеоуроки
  // XXX need refactoring
  $('#construct').find('a[data-item=help], ul[data-subitem=help] a:not(.active)').live('click', function() {
    var setting = $('#construct [data-subitem=help] a.active').data('setting');
    $('#construct .settings [data-setting^=help]').each(function() {
      $(this).html('');
    });
    var container = $('#construct .settings [data-setting="help::' + setting + '"]');
    container.html(embedVideo(container.data('url')));
  });
  $('#construct a[data-item]').click(function() {
    if ($(this).data('item') != 'help') {
      $('#construct .settings [data-setting^=help]').each(function() {
        $(this).html('');
      }); 
    }
  });
});

/**
 * Конструктор сайта
 */
function Construct()
{
    /**
     * Приминение палитры
     */
    /*$('.picker input').minicolors({
        inline: true,
        change: function(){
          var picker = $(this).closest('.picker');
          var input = $('minicolors-input', picker)
          var name = this.name;
          
          $('.result', picker).css('background', this.value);
          if ($(this).parents('div.setting').data('setting') == 'header::color_background') {
            $('#site_header_color_background').val(this.value);
            $('#header_color_background').attr('style', 'background: ' + this.value + ' !important;');
            $('#site_clear_tmp_header_image_background').after('<input type="hidden" name="site[remove_header_image_background]" value="true" form="save_site_form" />');
            $('#site_header_image_background').remove()
          } else if ($(this).parents('div.setting').data('setting') == 'background::internal') {
            $('#site_internal_color_background').val(this.value);
            $('[data-setting=internal_color_background]').attr('style', 'background: ' + this.value + ' !important;');
          } else if ($(this).parents('div.setting').data('setting') == 'background::external') {
            $('#site_external_color_background').val(this.value);
            $('.container[data-setting=external_color_background]').attr('style', 'background: ' + this.value + ' !important;');
            $('#site_clear_tmp_external_image_background').after('<input type="hidden" name="site[remove_external_image_background]" value="true" form="save_site_form" />');
            $('#site_external_image_background').remove();
          } else if ($(this).attr('name') == 'menu_text_color') {
            $('#site_menu_text_color').val(this.value);
            $('#menu_text_color_stylesheet').html('#site header .navigation li a { color:' + this.value + '}');
          } else if ($(this).attr('name') == 'menu_text_hover_color') {
            $('#site_menu_text_hover_color').val(this.value);
            $('#menu_text_hover_color_stylesheet').html('#site header .navigation li a:hover { color:' + this.value + '}');
          } else if ($(this).attr('name') == 'menu_background_color') {
            $('#site_menu_background_color').val(this.value);
            $('[data-setting=menu_background_color]').attr('style', 'background:' + this.value + ' !important;');
          } else if ($(this).attr('name') == 'menu_background_hover_color') {
            $('#site_menu_background_hover_color').val(this.value);
            $('#menu_background_hover_color_stylesheet').html('#site header .navigation li:hover { background:' + this.value + '}');
          } else if ($(this).attr('name') == 'text_title_color') {
            $('#site_text_title_color').val(this.value);
            $('#text_title_color_stylesheet').html('#site section.content .entity-title h2, #site section.content .title a { color: ' + this.value + ' !important; }');
          } else if ($(this).attr('name') == 'text_content_color') {
            $('#site_text_content_color').val(this.value);
            $('#text_content_color_stylesheet').html('#site section.content p { color: ' + this.value + ' };');
          } else if ($(this).attr('name') == 'info_title_text_color') {
            $('#site_info_title_text_color').val(this.value);
            $('#info_title_text_color_stylesheet').html('#site section.sidebar .title, #site section.sidebar .title a { color: ' + this.value + ' !important; }');
          } else if ($(this).attr('name') == 'info_title_background_color') {
            $('#site_info_title_background_color').val(this.value);
            $('#info_title_background_color_stylesheet').html('#site .title, #site .title a { background: ' + this.value + ' !important; }');
          } else if ($(this).attr('name') == 'info_content_text_color') {
            $('#site_info_content_text_color').val(this.value);
            $('#info_content_text_color_stylesheet').html('#site section.sidebar .content div, #site section.sidebar .content p, #site section.sidebar .content a { color: ' + this.value + ' !important; }');
          } else if ($(this).attr('name') == 'info_content_background_color') {
            $('#site_info_content_background_color').val(this.value);
            $('#info_content_background_color_stylesheet').html('#site section.sidebar .content, #site section.sidebar .content h2, #site section.sidebar .content div { background: ' + this.value + ' !important; }');
          } else if ($(this).attr('name') == 'footer_text_color') {
            $('#site_footer_text_color').val(this.value);
            $('#footer_text_color_stylesheet').html('#site footer p { color: ' + this.value + ' !important; }');
          } else if ($(this).attr('name') == 'footer_background_color') {
            $('#site_footer_background_color').val(this.value);
            $('#footer_background_color_stylesheet').html('#site footer { background: ' + this.value + ' !important; }');
          }

        }
    });*/
    
    
    
    /**
     * Фокус-покус
     */


    
    
    /**
     * Регистрация событий
     */
    this.bindEvents = function()
    {
        /**
         * Управление 2-м уровнем
         */
        $('#construct .items a').live('click', function(){
            var sub_item = $(this).attr('data-item');
            var setting = $('#construct .subItems ul[data-subitem="' + sub_item + '"] li:first a').attr('data-setting');
            
            //Открываем
            $('#construct .subItems ul').addClass('hidden');
            $('#construct .subItems ul[data-subitem="' + sub_item + '"]').removeClass('hidden');
            
            //Делаем первый пункт активным
            $('#construct .subItems ul[data-subitem="' + sub_item + '"] li a').removeClass('active');
            $('#construct .subItems ul[data-subitem="' + sub_item + '"] li:first a').addClass('active');
            
            //Отображение 3-го уровня
            $('#construct .settings .setting').addClass('hidden');
            $('#construct .settings .setting[data-setting="' + sub_item + '::' + setting + '"]').removeClass('hidden');
            
            //Выделяем текущий
            $('#construct .items a').removeClass('active');
            $(this).addClass('active');
            
            return false;
        });
        
        /**
         * Управление 3-м уровнем (сами настройки)
         */
        $('#construct .subItems a').live('click', function(){
            var data_subitem = $(this).closest('ul').attr('data-subitem');
            var data_setting = $(this).attr('data-setting');
            
            var setting = data_subitem + '::' + data_setting;
            
            $('#construct .settings .setting').addClass('hidden');
            $('#construct .settings .setting[data-setting="' + setting + '"]').removeClass('hidden');
            
            $('#construct .subItems a').removeClass('active');
            $(this).addClass('active');
            
            return false;
        });
        
        /**
         * Вкладки
         */
        $('#construct .setting .tabs a').live('click', function(){
            var setting = $(this).closest('.setting');
            var tab = $(this).attr('data-tab');
            
            $('.tab-content', setting).addClass('hidden');
            $('.tab-content', setting).removeClass('visible');
            $('.tab-content[data-tab="' + tab + '"]', setting).removeClass('hidden');
            $('.tab-content[data-tab="' + tab + '"]', setting).addClass('visible');
            
            $('.tabs a', setting).removeClass('active');
            $(this).addClass('active');
            
            return false;
        });
    }
    
    /**
     * Изменение стилей текстов
     */
    this.changeStyleText = function()
    {
        
    }
    
}
