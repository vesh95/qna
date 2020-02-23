import consumer from "./consumer"

var questionsChannel

$(document).on('turbolinks:load', function () {
  var $questionsList = $('#questions-list')
  if ($questionsList.length) {
    questionsChannel = consumer.subscriptions.create("QuestionsChannel", {
      received(data) {
        $questionsList.append(data.data)
      }
    }) // subscriptions.create()
  } else {
    if (questionsChannel) questionsChannel.unsubscribe()
  }
}) // on 'turbolinks:load'
