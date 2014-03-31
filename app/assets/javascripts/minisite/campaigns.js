$(function() {
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
    
  $('.send-campaign .send').live('click', function() {
    $(this).closest('form').submit();
    return false;
  });

  $('#sendCampaignBlock form').submit(function(event) {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    if (!$('#campaign_email').val()) {
      alert('Укажите email');
      event.preventDefault();
      return false;
    } else if (!$('#campaign_email').val().match(re)) {
      alert('Некорректный email');
      event.preventDefault();
      return false;
    } else {
      $(this).closest('.send-campaign').hide();
      return true
    }
  });
});
