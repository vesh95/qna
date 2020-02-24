export default function commentHtml(data) {
  return `
    <div class="comment">
      <i>by: ${data.data.user.email}</i>
      <p class="actions">
        ${data.data.text}
      </p>
    </div>
  `
}
