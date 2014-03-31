jQuery(document).ready(function($){
    
    var dir_images = 'mini-img/';
    
    /**
     * Раскрытие/скрытие блока "НаОбзоре" (самого верхнего)
     */
    $('#topViewHide').live('click', function()
    {
        var block = $('#topMenu');
    
        if(block.css('display') == 'block')
        {
            block.hide();
            $(this).text('Раскрыть');
            $(this).css('background', 'url(' + dir_images + 'top-view.png) left center no-repeat');
            $('#main_container').css('margin-top','25px');
        }
        else
        {
            block.show();
            $(this).text('Свернуть');
            $(this).css('background', 'url(' + dir_images + 'top-hide.png) left center no-repeat');
            $('#main_container').css('margin-top','100px');
        }
    });
    //alert($('#main_header').width());
    
    /**
     * Скрытие раскрытие расширенного меню в панели
     */
    $('#viewExtMenu').live('click', function()
    {
        var block = $('#extMenu');
        
        if(block.css('display') == 'block')
        {
            block.hide();
            $('img', $(this)).attr('src', dir_images + 'icon-view.png');
        }
        else
        {
            block.show();
            $('img', $(this)).attr('src', dir_images + 'icon-hide.png');
        }
    });
    
    $('#main_container').live('click', function()
    {
        $('#extMenu').hide();
        $('#viewExtMenu img').attr('src', dir_images + 'icon-view.png');
    });
    
});