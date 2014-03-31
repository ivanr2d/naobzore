jQuery(document).ready(function($) {
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
    
});
