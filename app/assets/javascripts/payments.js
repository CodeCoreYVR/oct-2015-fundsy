$(document).ready(function(){
  Stripe.setPublishableKey($("meta[name=stripe-pk]").attr("content"));

  $("#stripe-form").on("submit", function(){
    event.preventDefault();
    // Clear error messages before attempting to create the token
    $("#stripe-error-message").html("");
    // This makes an AJAX request to the Stripe server to generate the token
    Stripe.card.createToken($(this), stripeResponseHandler);

    // in jQuery if the forms submit event handler return false it will be
    // equivalent to:
    // event.preventDefault();
    // event.stopPropagation();
    // return false;
  });

  var stripeResponseHandler = function(status, response) {
    console.log(status);
    console.log(response);
    if(status === 200) {
      $("#stripe_token").val(response.id);
      $("#submission-form").submit();
    } else {
      $("#stripe-error-message").html(response.error.message)
    }
  }

});
