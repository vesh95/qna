import consumer from "./consumer"

$(document).on('turbolinks:load', function () {
  var $questionsList = $('#questions-list')
  consumer.subscriptions.create("QuestionsChannel", {
    received(data) {
      $questionsList.append(data.data)
    }
  })
})
