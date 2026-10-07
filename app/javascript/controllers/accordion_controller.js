import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body", "icon"]

  toggle(event) {
    const isClosed = this.bodyTarget.classList.toggle("hidden")

    if (event?.currentTarget) {
      event.currentTarget.setAttribute("aria-expanded", String(!isClosed))
    }

    if (this.hasIconTarget) {
      this.iconTarget.classList.toggle("rotate-180", !isClosed)
    }
  }
}
