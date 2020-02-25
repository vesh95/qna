import consumer from "./consumer"
import answerHtml from "../templates/answer"

var questionsAnswersChannel

$(document).on('turbolinks:load', function(){
  var questionId = $("#question").data('question-id')
  if (questionId) {
    questionsAnswersChannel = consumer.subscriptions.create({
      channel: 'QuestionAnswersChannel', question_id: questionId
    }, {
      received(data) {
        console.log(data);
        if (gon.user_id !== data.data.answer.user_id) $('.answers').append(answerHtml(data))
      }
    })
  } else {
    if (questionsAnswersChannel) questionsAnswersChannel.unsubscribe()
  }
})
