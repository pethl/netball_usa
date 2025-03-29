import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]
  static values = { prefix: String }

  update(event) {
    const label = event.currentTarget.dataset.label
    if (this.hasTextTarget && label) {
      const prefix = this.hasPrefixValue ? `${this.prefixValue} – ` : ""
      this.textTarget.textContent = `${prefix}${label}`
    }
  }
}

