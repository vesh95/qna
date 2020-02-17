$(document).on('turbolinks:load', function() {
  $('.voting').on('ajax:success', function(event) {
    var response = event.detail[0];
    var $voted = $(`#vote-${response.klass}-${response.id}`)
    $('.rating', $voted).text(response.rating)
    $('.voting', $voted).addClass('hidden')
    $('.revoting', $voted).removeClass('hidden')
  })

  $('.revoting').on('ajax:success', function(event) {
    var response = event.detail[0];
    var $voted = $(`#vote-${response.klass}-${response.id}`)
    $('.rating', $voted).text(response.rating)
    $('.voting', $voted).removeClass('hidden')
    $('.revoting', $voted).addClass('hidden')
  })
})
