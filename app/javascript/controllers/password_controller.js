import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["masked", "plain", "feedback"]

  toggle() {
    this.maskedTarget.classList.toggle("hidden")
    this.plainTarget.classList.toggle("hidden")
  }

  copy() {
    const text = this.plainTarget.textContent.trim()
    navigator.clipboard.writeText(text)

    this.showFeedback()
  }

  showFeedback() {
    this.feedbackTarget.classList.remove("hidden")

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.feedbackTarget.classList.add("hidden")
    }, 1500)
  }
}

