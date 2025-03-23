// app/javascript/controllers/inline_edit_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  load() {
    console.log("➡️ InlineEdit#load triggered:", this.urlValue)

    fetch(this.urlValue, {
      headers: { Accept: "text/vnd.turbo-stream.html" } // important!
    })
    .then(response => response.text())
    .then(html => {
      console.log("📦 Injecting Turbo Stream response")
      Turbo.renderStreamMessage(html)
    })
    .catch(err => console.error("❌ Inline edit fetch failed:", err))
  }
}
