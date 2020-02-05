$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    let answerId = $(this).data('answerId')

    let r = $(`.answer[data-answer-id=${answerId}] .edit`).toggleClass('hidden')
  })
})
