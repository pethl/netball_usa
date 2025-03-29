import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = {
    url: String,
    delay: Number
  }

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const query = this.inputTarget.value.trim()
      const url = new URL(this.urlValue, window.location.origin)
      url.searchParams.set("search", query)

      // Let Turbo handle the full stream response
      Turbo.visit(url.toString())
    }, this.delayValue || 300)
  }
}
