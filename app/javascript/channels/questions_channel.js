import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  var $questionsList = $('#questions-list')
  if ($questionsList.length) {
    consumer.subscriptions.create("QuestionsChannel", {
      received(data) {
        console.log(data);
        if (data.action == 'create') {
          $('#questions').append(data.data)
        }
        if (data.action == 'destroy') {
          $(`#question-id-${data.id}`).remove()
        }
      },
    })
  }
})
