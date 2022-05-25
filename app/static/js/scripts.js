// Tooltips

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
});

// Trigger add new project member form

$(document).ready(function(){
  $('#toggle-assigned-member-form').click(function(e) {
    e.preventDefault();
    $('.assign-member-form').toggleClass('trigged');
  });
});
