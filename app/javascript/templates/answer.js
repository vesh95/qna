export default function answerHtml(data) {
  return `
    <div class="answer" data-answer-id="${data.data.answer.id}">
      ${data.data.answer.body}
      <div class="actions">
        <a href="/answers/${data.data.answer.id}/load" data-remote="true">Load</a>
      </div>
    </div>
  `
}
