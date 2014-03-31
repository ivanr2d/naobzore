

function carousel(obj)
{
    var o_auto = true;
    var o_time = 8000;
    var o_speed = 500;
    var o_btnNext = '.slide-next';
    var o_btnPrev = '.slide-prev';
    
    
    var ul = $('ul', obj);
    var li = $('li', obj);

    var item_width = null;
    var block_all_width  = null;

    var count = li.length;
    var pos   = 1;//позиция

    var first = null;
    var last  = null;
    var second = null;
    var plast = null;

    var running = true;
    var interval = null;    
    
    if(count > 0)
    {
        item_width = 557;
        block_all_width  = item_width * count;
    }

    if(count >= 2)
    {
        count += 2;

        first = $('.' + obj.attr('class') + ' ul li:first').clone();
        second = $('.' + obj.attr('class') + ' ul li:first').next().clone();

        last = $('.' + obj.attr('class') + ' ul li:last').clone();
        plast = $('.' + obj.attr('class') + ' ul li:last').prev().clone();

        ul.append(first);
        ul.append(second);
        ul.prepend(last);
        ul.prepend(plast);

        block_all_width += item_width * 2;
        ul.css('marginLeft', - (370 + item_width) + 'px');
    }
    else if(count == 1)
    {
        block_all_width += item_width;
        ul.css('marginLeft', '187px');
    }

    obj.css('width', block_all_width);
    
        if(o_btnNext)
        {
            if(count > 1)
            {
                $(o_btnNext).click(function(){
                    if(o_auto)
                    {
                        stopInterval();
                        startInterval();
                    }
                    return next();
                });
            }
        }
        if(o_btnPrev)
        {
            if(count > 1)
            {
                $(o_btnPrev).click(function(){
                    if(o_auto)
                    {
                        stopInterval();
                        startInterval();
                    }
                    return prev();
                });
            }
        }
    
    if(o_auto)
    {
        startInterval();
    }

    function startInterval()
    {
        interval = setInterval(next, o_time);
    }
    function stopInterval()
    {
        clearInterval(interval);
    }
    
    function prev()
    {
        if(running)
        {
            running = false;

            if(pos-1 != 0)
            {
                ul.animate({'margin-left' :  '+=' + item_width + 'px'}, o_speed, null, function(){ pos--; running=true; });
            }
            else if(pos-1 == 0)
            {
                var count_temp = count-1;
                ul.css('marginLeft', -((item_width * (count-1)) + 370) + 'px');
                ul.animate({'margin-left' :  '+=' + item_width + 'px'}, o_speed, null, function(){ pos--; running=true; });
                pos = count-1;
            }
        }
    }
    function next()
    {
        if(running)
        {
            running = false;

            if(pos+1 != count-1)
            {
                ul.animate({'margin-left' :  '-=' + item_width + 'px'}, o_speed, null, function(){ pos++; running=true; });
            }
            else if(pos+1 == count-1)
            {
                ul.css('margin-left', - (370) + 'px');
                ul.animate({'margin-left' :  '-=' + item_width + 'px'}, o_speed, null, function(){ pos++; running=true; });
                pos = 0;
                //alert(pos)
            }
        }
    }
}
