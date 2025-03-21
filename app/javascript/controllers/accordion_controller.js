import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["body"]

  toggle() {
    this.bodyTarget.classList.toggle("hidden")
  }
}
