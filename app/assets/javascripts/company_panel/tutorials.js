jQuery(document).ready(function($) {
    /**
     * ! Событие
     * Открытие окна с видео 
     */
	$('.capability-video').live('click', function()
	{
		var video_id = $(this).attr('data-capability');
		$('#mask').width($(document).width());
		$('#mask').height($(document).height());
		$('#mask').show();
		$('#video_capability_' + video_id).show();
	});
    /**
     * ! Событие
     * Закрытие окна с видео на главной странице
     */
    $('.video-about-close').live('click', function()
    {
    	$(this).parent().parent().parent().hide();
    	$('#mask').hide();
    	return false;
    });
});
