/**
 * kwet 0.1 Alpha
 */
(function( $ ){

    var Table = {
        
        options : 0,
        
        parent : 0,
        table  : 0,
        tbody  : 0,
        thead  : 0,
        
        count_rows : 0,
        count_cols : 0,
        
        pressed : false,
        
        width_columns : 0,
        
        init : function(parent, options)
        {
            this.options = options;

            this.parent = parent;
            this.table = $('table', parent);
            this.thead = $('thead', this.table);
            this.tbody = $('tbody', this.table);
            
            this.count_rows = $('tr', this.table).length;
            this.count_cols = $('tr:first th', this.table).length;
            
            this.width_columns = this.getWidthColumns();
            
            scroll_x = 0,
            
            this.widthColumnsSetting();
            this.scrollSetting();
            this.resizingSetting();
            this.changeWidth();
            this.styleSetting();
            
            //$('.control_size', this.thead).bind('mousedown.kwet', Table.mouse_down);
            //$(this.thead).bind('mouseup.kwet', Table.mouse_up);
            //$(this.thead).bind('mousemove.kwet', Table.mouse_move);
            
            return this;
        },
        
		/**
		 * Установка элементов для управления ширины ячеек
		 */
        resizingSetting : function()
        {
        	$('th', this.thead).each(function(index)
        	{
        		var padding_right  = parseInt($(this).css('padding-right'));
        		var outer_width  = $(this).outerWidth();
        		var line_height = parseInt($(this).css('line-height'));
        		
        		$(this).append('<div class="control_size" data-index="' + index + '">&nbsp;</div>');
        		
        		$('.control_size', $(this)).css({
        			position : 'relative',
        			'z-index' : 5,
        			marginLeft : outer_width - padding_right - 3,
        			height : line_height,
        			cursor : 'col-resize',
        			width  : 5,
        			marginTop : -(line_height)
        		});
        	});
        },
        
        /**
         * Установка ширины ячеек
         */
        widthColumnsSetting : function()
        {
            width_columns = this.width_columns;
            
            $('tr', this.table).each(function()
            {
            	var _cell = 0;
            	
            	$('td, th', $(this)).each(function()
            	{
            		$(this).css({
                        'min-width' : width_columns[_cell] + 'px',
                        'max-width' : width_columns[_cell] + 'px'
                    });
                    
                    _cell++;
            	});
            });
        },
        
        /**
         * Получение величин широких ячеек
         */
        getWidthColumns : function(padding)
        {
            if (typeof padding == "undefined") padding = false;
            
        	var result = new Array(this.count_cols);
        	var row = 0;
        	
        	for(var i = 0; i < result.length; i++) result[i] = 0;

        	$('tr', this.table).each(function()
        	{
        		var cell = 0;
        		
        		$('td, th', $(this)).each(function()
        		{
        			if(result[cell] < $(this).outerWidth())
        			{
                        var cell_padding = parseInt($(this).css('padding-left')) + parseInt($(this).css('padding-right'));
        				result[cell] = $(this).outerWidth() - 1;
                        if(padding) result[cell] += cell_padding;
        			}
        			cell++;
        		});
        		
        		row++;
        	});
        	
        	return result;
        },
        
        /**
         * Установка необходимых стилей
         */
        styleSetting : function()
        {
            this.parent.css({
            	marginTop : parseInt(this.table.css('margin-top')),
            	marginBottom : parseInt(this.table.css('margin-bottom')),
            });
            this.table.css({
                display : 'block',
                width : this.options.width,
                height : this.options.height,
                marginTop : 0,
                marginBottom : 0
            });
            this.thead.css({
                display : 'block',
                'overflow-x' : 'hidden'
            });
            this.tbody.css({
                display : 'block',
                'overflow-y': 'scroll',
                'overflow-x': 'hidden',
                height : this.options.height - this.thead.outerHeight(),
            });
            this.scroll_x.css({
                width : this.options.width,
                'overflow-y': 'hidden',
                'overflow-x': 'scroll',
                height : 16,
            });
        },
        
        /**
         * Поучение суммы элементов массива
         */
        arrSum : function(array)
        {
            result = 0;
            if(array.length > 0) for(var i = 0; i < array.length; i++) result += array[i];
            return result;
        },
        
        /**
         * Установка скролла
         */
        scrollSetting : function()
        {
            tbody  = this.tbody;
            thead  = this.thead;
            width  = $('tr:first', thead).outerWidth();
            
            var scroll_x_html = '<div class="scroll-x"><div>&nbsp;</div></div>';
            this.parent.append(scroll_x_html);
            
            var scroll_x = $('.scroll-x', this.parent);
            this.scroll_x = scroll_x;
            $('div', scroll_x).css('width', width);
            
            scroll_x.scroll(function(){
                var position = scroll_x.scrollLeft();
                tbody.scrollLeft(position);
                thead.scrollLeft(position);
            });
        },
        
        changeWidth : function()
        {
            var pressed = false;
            var item = undefined;
            var start_x = 0;
            var start_width = 0;
            var index = undefined;
            var element = undefined;
            
            $('.control_size', this.thead).mousedown(function(e)
            {
            	pressed = true;
            	item = $(this).parent();
            	start_x = e.pageX;
            	start_width = parseInt(item.css('min-width'));
            	index = $(this).attr('data-index');
                element = $(this);
            });
            
		    $(this.thead).mousemove(function(e)
		    {
		        if(pressed)
		        {
		            $('#debug').html(e.pageX);
		            
                    var new_width = start_width + (e.pageX - start_x)
                    
                    if(new_width >= Table.width_columns[index])
                    {
                        $('td:eq(' + index + ')', Table.tbody).css('min-width', new_width + 'px');
                        $('td:eq(' + index + ')', Table.tbody).css('max-width', new_width + 'px');
                        item.css('min-width', new_width + 'px');
                        item.css('max-width', new_width + 'px');
                        
                        var padding_right  = parseInt(item.css('padding-right'));
                        element.css('margin-left', new_width + padding_right - 3);
                        
                        var temp = Table.getWidthColumns(true);
                        temp[index] = new_width - padding_right * 2 + 5;
                        $('div', Table.scroll_x).css('width', Table.arrSum(temp));
                        
                    }
		        }
		    });
		    
		    $(this.thead).mouseup(function()
		    {
		        if(pressed)
		        {
		            pressed = false;
		        }
		    });
        }
    }

    $.fn.kwet = function(params)
    {
        /**
         * Свойства
         * Пример: options.width
         */
        options = $.extend({
            'width' : 500,
            'height' : 380
        }, params);
        
        var _make = function()
        {
            var table = Table.init($(this), options);
        }
        
        return this.each(_make);
    };
})(jQuery);

$(document).ready(function(){
    $('.kepweb_excel').kwet({width: 660, height: 150});
});
