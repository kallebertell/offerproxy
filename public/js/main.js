;(function() {
  'use strict';

  var $form = $('.offer-form');

  var $uidInput = $('#uid');
  var $pub0Input = $('#pub0');
  var $pageInput = $('#page');

  var $results = $('.results');
  
  var offerTemplate = $('#offerTemplate').html();

  $form.submit(function() {
    fetchOffers();
    return false;
  });

  function fetchOffers() {
    showMessageInResults('Loading..');

    $.ajax({
      method: 'GET',
      content: 'application/json',
      url: '/api/v1/offers',
      data: {
        device_id: '2b6f0cc904d137be2e1730235f5664094b83',
        ip: '109.235.143.113',
        locale: 'de',
        offer_types: '112',
        uid: $uidInput.val(),
        pub0: $pub0Input.val(),
        page: $pageInput.val()
      }
    }).then(showResults, showError);
  }

  function showResults(result) {

    if (!result.offers || result.offers.length < 1) {
      showMessageInResults('Looks like there are no offers available at the moment.');
      return;
    }

    var newHtml = result.offers.map(function(offer) {
      return offerTemplate
          .replace('{{title}}', offer.title)
          .replace('{{thumbnail}}', offer.thumbnail.lowres)
          .replace('{{payout}}', offer.payout)
      
    }).join('');

    $results.html(newHtml);
  }

  function showError(error) {
    showMessageInResults(error.responseJSON.message);
  }

  function showMessageInResults(message) {
    $results.html('<p class="results__help">' + message + '</p>');
  }

})();

