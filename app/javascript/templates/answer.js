export default function answerHtml(data) {
  return `
    <div class="answer card" data-answer-id="${data.data.answer.id}">
      ${data.data.answer.body}
      <div class="actions">
        <a href="/answers/${data.data.answer.id}" data-remote="true">Load</a>
      </div>
      <h6>Comments</h6>
      <div class="comments" id="answer-comments-${data.data.answer.id}">
    </div>
  `
}
