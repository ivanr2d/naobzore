$(function() {
  /**
   * Отображение блока "Отправить резюме"
   */
  $('#sendResume').click(function(){
      if($('#sendResumeBlock').css('display') == 'none')
      {
          $('#sendResumeBlock').show();
      
          jQuery('.scrollpane').jScrollPane({trackClickSpeed:40});
          
      }
      else
          $('#sendResumeBlock').hide();
      return false;
  });
  // Скрытие вышеописанного блока
  $(document).click(function(event){
      if ($(event.target).closest(".send-resume").length) return;
      $('.send-resume').hide();
      event.stopPropagation();
  });
  // Еще одно скрытие вышеописанного блока
  $('.send-resume .cancel').click(function(){
      $(this).closest(".send-resume").hide();
      return false;
  });
  
  $('.send-job-resume').on('ajax:complete', function(event, data) {
    data = JSON.parse(data.responseText);
    console.debug(data);
    if (data.success) {
      $('#sendResumeBlock').hide();
    } else {
      alert(data.error.join("\n"));
    }
  });
});
