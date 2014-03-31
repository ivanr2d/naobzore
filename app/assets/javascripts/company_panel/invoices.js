$(function() {  
  $('#company_kpp').mask("999999999");
  $('#invoice_sum').live_mask(/^\d+$/);

  $('.pay-invoice').on('ajax:complete', function(data) {
    $(this).replaceWith($(this).text());
    $('tr[data-id=' + $(this).data('id') + '] .invoice-status').text('Оплачен');
  });
});
