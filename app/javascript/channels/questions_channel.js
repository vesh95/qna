import consumer from "./consumer"

var questionsChannel

$(document).on('turbolinks:load', function () {
  var $questionsList = $('#questions-list')
  if ($questionsList.length) {
    questionsChannel = consumer.subscriptions.create("QuestionsChannel", {
      received(data) {
        switch(data.data.action) {
          case 'create':
            $questionsList.append(data.data.question)
            break
          case 'destroy':
            $(`#question-id-${data.data.id}`).remove()
            break
        }
      }
    }) // subscriptions.create()
  } else {
    if (questionsChannel) questionsChannel.unsubscribe()
  }
}) // on 'turbolinks:load'
