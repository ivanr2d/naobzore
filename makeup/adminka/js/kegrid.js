(function( $ ){
    
    var Kegrid = function(table, options)
    {
        this._options = options;
        
        this._table = table;
        this._thead = $('thead', table);
        this._tbody = $('tbody', table);
        
        this._count_rows = $('tr', this._tbody).length;
        this._count_cols = $('tr:first th', this._thead).length;
        
        this._width = new Array(this._count_cols);
        this._outer_width = new Array(this._count_cols);
        this._default_width = new Array(this._count_cols);
        
        var thead_html = this._thead.html();
        var tbody_html = this._tbody.html();
        
        this._main_container = $('<div/>', {
            'class' : 'kegrid-main-container'
        });
        this._head_container = $('<div/>', {
            'class' : 'kegrid-head-container'
        });
        this._body_container = $('<div/>', {
            'class' : 'kegrid-body-container'
        });
        this._horizontal_scroll = $('<div/>', {
            'class' : 'kegrid-horizontal-scroll'
        });
        this._scroll_content = $('<div/>', {
            'class' : 'kegrid-scroll-content'
        });
        
        this._head_table = $('<table/>', {
            'class' : 'kegrid-head-table style-silver',
            html    : thead_html,
            cellpadding : 0,
            cellspacing : 0
        });
        this._body_table = $('<table/>', {
            'class' : 'kegrid-body-table style-silver',
            html    : tbody_html,
            cellpadding : 0,
            cellspacing : 0
        });
        
        /**
         * Конструктор таблицы
         */
        this.construct = function()
        {
            this._head_container.append(this._head_table);
            this._body_container.append(this._body_table);
            this._horizontal_scroll.append(this._scroll_content);
            
            this._main_container.append(this._head_container);
            this._main_container.append(this._body_container);
            this._main_container.append(this._horizontal_scroll);
            
            this._table.after(this._main_container).remove();
            
            this.settingWidth();
            this.settingStyle();
            
            this.settingControlElementsSize();
        }
        
        /**
         * Установка ширины всем элементам
         */
        this.settingWidth = function()
        {
            var tbody_height = this._options.height - this._head_container.height();
            var max_width = Math.max(this._body_table.width(), this._head_table.width());
            
            // Ширина контейнеров
            this._main_container.width(this._options.width);
            this._head_container.width(this._options.width);
            this._body_container.width(this._options.width);
            this._horizontal_scroll.width(this._options.width);
            
            // Ширина таблиц
            this._body_table.css('width', max_width);
            this._head_table.css('width', max_width);
            
            // Ширина ячейкам
            this._width = getWidthColumns([this._head_table, this._body_table], this._count_cols);
            this._outer_width = getWidthColumns([this._head_table, this._body_table], this._count_cols, true);
            
            changeWidthColumns([this._head_table, this._body_table], this._width);
            this._default_width = getWidthColumns([this._head_table, this._body_table], this._count_cols);
            
<<<<<<< Updated upstream
            // (!) Строка для пересмотра (не коректна)
            this._scroll_content.css('width', summa(this._outer_width) + (this._count_cols - 3));
=======
            this._scroll_content.css('width', summa(this._outer_width));
>>>>>>> Stashed changes
            
            // Высота tbody
            this._body_container.height(tbody_height);
        }
        
        /**
         * Изменение ширины ячеек
         * @param array tables - Таблицы
         * @param array width - Величины колонок
         */
        var changeWidthColumns = function(tables, width)
        {
            for(var i = 0; i < tables.length; i++)
            {
                $('tr', tables[i]).each(function(){
                    $('td, th', $(this)).each(function(index)
                    {
                        $(this).css('max-width', width[index]);
                        $(this).css('min-width', width[index]);
<<<<<<< Updated upstream
                    });
=======
                    })
>>>>>>> Stashed changes
                });
            }
        }
        
        var getWidthColumns = function(tables, count, padding)
        {
            if (typeof padding == "undefined") padding = false;
            var result = new Array(count);
            
            for(var i = 0; i < count; i++) result[i] = 0;
            
            for(var i = 0; i < tables.length; i++)
            {
                $('tr', tables[i]).each(function(){
<<<<<<< Updated upstream
                    $('th, td', $(this)).each(function(index)
=======
                    $('td, th', $(this)).each(function(index)
>>>>>>> Stashed changes
                    {
                        if(result[index] < $(this).width())
                        {
                            result[index] = $(this).width();
                            if(padding) result[index] = $(this).outerWidth();
                        }
                    })
                });
            }
            return result;
        }
        
        /**
         * Установка элементов управления размером
         */
        this.settingControlElementsSize = function()
        {
            $('tr:first th', this._head_table).each(function(index)
            {
                var element = $('<div/>', {
                    'html'  : '&nbsp;',
                    'class' : 'kegrid-element-control-size',
                    'css'   : {
                        width    : 10,
                        position : 'relative',
                        cursor : 'col-resize',
                        marginTop   : -(parseInt($(this).css('font-size'))),
                        marginLeft  : $(this).innerWidth() - parseInt($(this).css('padding-right')) - 5,
                        marginRight : -(parseInt($(this).css('padding-right')) + 5),
                        border : '0px solid red'
                    }
                });
                
                $(this).append(element);
            });
        }
        
        /**
         * Установка необходимых для таблицы стилей
         */
        this.settingStyle = function()
        {
            this._main_container.css({
                
            });
            this._head_container.css({
                position  : 'relative',
                overflowX : 'hidden'
            });
            this._body_container.css({
                position  : 'relative',
                overflowX : 'hidden',
                overflowY : 'scroll'
            });
            this._horizontal_scroll.css({
                overflowX : 'scroll',
                overflowY : 'hidden',
                height    : 17,
            });
            this._scroll_content.css({
                height : 1
            });
            $('.kegrid-main-container table, .kegrid-main-container tr').css({
                display : 'block'
            });
<<<<<<< Updated upstream
            $('.kegrid-main-container table tr td, .kegrid-main-container table th').css({
                textAlign : 'center'
            });
=======
>>>>>>> Stashed changes
        }
        
        /**
         * Горизонтальная прокрутка
         */
        this.bindScroll = function()
        {
            var horizontal_scroll = this._horizontal_scroll;
            var body_container = this._body_container;
            var head_container = this._head_container;
            
            horizontal_scroll.scroll(function(){
                var position = horizontal_scroll.scrollLeft();
                body_container.scrollLeft(position);
                head_container.scrollLeft(position);
            });
        }
        
        this.bindResizeColumn = function()
        {
            var pressed = false;
            
            var begin_w = 0;
            var begin_x = 0;
            var begin_o = 0;
            
            var column = undefined;
            var elemen = undefined;
            
            var tables = [this._head_table, this._body_table];
            
            var width  = this._width;
            var default_width = this._default_width;
            var outer_width = this._outer_width;
            
            var scroll_content = this._scroll_content;
            
            // Нажата клавиша
            $('.kegrid-element-control-size', this._head_table).mousedown(function(e){
                pressed = true;
                
                column = $(this).parent();
                elemen = $(this);
                
                begin_x = e.pageX;
                begin_w = parseInt(column.css('width'));
                begin_o = column.outerWidth();
<<<<<<< Updated upstream
                
                return false;
                onselectstart = function() {return false}
            });
            
            // Отпущена клавиша
            $(document).mouseup(function(e){
=======
            });
            
            // Отпущена клавиша
            $(this._head_table).mouseup(function(e){
>>>>>>> Stashed changes
                if(pressed) pressed = false;
            });
            
            // Движение мыши
<<<<<<< Updated upstream
            $(document).mousemove(function(e){
=======
            $(this._head_table).mousemove(function(e){
>>>>>>> Stashed changes
                if(pressed)
                {
                    var new_width = begin_w + (e.pageX - begin_x);
                    var new_outer_width = begin_o + (e.pageX - begin_x);
                    
                    if(default_width[column.index()] <= new_width)
                    {
                        // Изменение размера колонки
                        width[column.index()] = new_width;
                        changeWidthColumns(tables, width);
                        
                        // Движение элемента управления размером
                        elemen.css({
                            marginLeft: new_width + parseInt(column.css('padding-right')) - 6
                        });
                        
                        // Изменение размера скролла
                        outer_width[column.index()] = new_outer_width;
                        scroll_content.css('width', summa(outer_width));
                    }
                }
            });
        }
        
<<<<<<< Updated upstream
        function summa(array)
=======
        var summa = function(array)
>>>>>>> Stashed changes
        {
            var result = 0;
            for(var i = 0; i < array.length; i++) result += array[i]; 
            return result;
        }
        
        // Собираем таблицу
        this.construct();
        
        // Регистрация событий (временно (!)РАЗДЕЛИТЬ НА ЛОГИЧЕСКИЕ ОБЛАСТИ)
        this.bindScroll();
        this.bindResizeColumn();
    }
    
    $.fn.kegrid = function(params)
    {
        /**
         * Свойства
         * Пример: options.width
         */
        _options = $.extend({
            'width' : 500,
            'height' : 380
        }, params);
        
        var make = function()
        {
            var table = new Kegrid($(this), _options);
        }
        
        return this.each(make);
    };

})(jQuery);

$(document).ready(function(){
<<<<<<< Updated upstream
    $('.kegrid').kegrid({width: 660, height: 150});
=======
    $('.kegrid').kegrid({width: 662, height: 150});
>>>>>>> Stashed changes
});
