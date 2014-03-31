/**

**/
(function( $ ){

    var Table = {
        
        options : 0,
        
        count_rows : 0,
        count_cols : 0,
        
        table : 0,
        thead : 0,
        tbody : 0,
        
        LEFT : 0,
        
        init : function(table, options)
        {
            this.options = options;
            this.table = table;
            this.thead = $('thead', table);
            this.tbody = $('tbody', table);
            
            this.count_rows = $('tr', table).length;
            this.count_cols = $('tr:first th', table).length;
            
            //this.LEFT = this.tbody.css('left');
            this.LEFT = 413;
            
            this.elementsSetting();
            this.scrollSetting();
            this.widthSetting();
            this.styleSetting();
            return this;
        },
        
        /**
         * Присвоить цсс ячейк блоку контент а с ячейки удалить
         * (!)
         */
        elementsSetting : function()
        {
            $('th', this.thead).each(function()
            {
                var content = $(this).text();
                var new_content = '';
                
                new_content += '<div class="comtab-th-content">';
                new_content += content;
                new_content += '</div>';
                new_content += '<div class="comtab-th-element">|</div>';
                
                //$(this).html(new_content);
                
            });
        },
        
        /**
         * Установка стилей
         */
        styleSetting : function()
        {
            this.table.css({
                'height' : this.options.height + this.thead.height() + 16 + 'px',
                'width'  : this.options.width - 16 + 'px',
                'overflow-x' : 'scroll',
                'overflow-y' : 'hidden',
                'display' : 'block',
                'position' : 'relative',
            });
            this.thead.css({
                'display' : 'block',
                'min-width' : this.options.width - 20 + 'px',
                'max-width' : this.options.width - 20 + 'px',
            });
            this.tbody.css({
                'display' : 'block',
                'position' : 'absolute',
                'overflow-y' : 'scroll',
                'overflow-x' : 'hidden',
                'padding-right' : '20px;',
                'border' : '1px solid red',
                'height' : this.options.height + 'px',
                'max-width'  : this.options.width - 16 + 'px',
                'min-width'  : this.options.width - 16 + 'px',
            });
            $('tr', this.table).css({
                //'display' : 'block',
            });
            $('.Tcomtab-th-content', this.table).css({
                'float' : 'left',
            });
            $('.Tcomtab-th-element', this.table).css({
                'display' : 'inline-block',
            });
            
        },
        
        /**
         * Установка ширины ячеек исходя из ширины заголовочных ячеек
         * 1. Найти самую длинную строку
         * 2. Исходя из длинной строки устанавливаем ширину ячейкам
         */
        widthSetting : function()
        {
            width = this.getWidthColumns();
            
            $('tr', this.table).each(function()
            {
            	var _cell = 0;
            	
            	$('td, th', $(this)).each(function()
            	{
            		$(this).css({
                        'min-width' : width[_cell] + 'px',
                        'max-width' : width[_cell] + 'px'
                    });
                    
                    _cell++;
            	});
            });
        },
        
        /**
         * Получение ширины ячейки по столбцу
         */
        getWidthColumns : function()
        {
        	var result = new Array(this.count_cols);
        	
        	for(var i = 0; i < result.length; i++) result[i] = 0;
        	
        	var row = 0;
        	
        	$('tr', this.table).each(function()
        	{
        		var cell = 0;
        		
        		$('td, th', $(this)).each(function()
        		{
        			if(result[cell] < $(this).outerWidth())
        			{
        				result[cell] = $(this).outerWidth() - 1;
        			}
        			
        			cell++;
        		});
        		
        		row++;
        	});
        	
        	return result;
        },
        
        /**
         * Установка скролла
         */
        scrollSetting : function()
        {
            table = this.table;
            tbody = this.tbody;
            thead = this.thead;
            LEFT = this.LEFT;
            
            table.scroll(function(){
                var position = table.scrollLeft();
                tbody.scrollLeft(position);
                tbody.animate({left : 1});
            });
        }
    }

    $.fn.complexTable = function(params)
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
    $('table.complexTable').complexTable({width: 800, height: 300});
});
