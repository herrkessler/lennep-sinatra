function templateSuccess(message){
  var template = '<p class="success"><span>✔ </span>'+message+'</p>';
  return template;
}

function templateError(message){
  var template = '<p class="error"><span>✔ </span>'+message+'</p>';
  return template;
}

function flash(message, type) {
  if (type == 'error') {
    $('#flash-message .container').append(templateError(message));
  }
 if (type == 'success') {
    $('#flash-message .container').append(templateSuccess(message));
  }
}