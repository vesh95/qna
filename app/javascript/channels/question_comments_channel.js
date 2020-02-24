import consumer from "./consumer"
import commentHtml from "../templates/comment"

var questionCommentsChannel

$(document).on('turbolinks:load', function () {
  var questionId = $("#question").data('question-id')
  if (questionId) {
    questionCommentsChannel = consumer.subscriptions.create({
      channel: "QuestionCommentsChannel", question_id: questionId
    }, {
      received(data) {
        // console.log(data);
        $(`#${data.data.type}-comments-${data.data.id}`).append(commentHtml(data))
      }
    });
  } else {
    if (questionCommentsChannel) questionCommentsChannel.unsubscribe()
  }
})
