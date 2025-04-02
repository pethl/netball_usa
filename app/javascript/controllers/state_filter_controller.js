import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "results"]
  static values = {
    url: String
  }

  connect() {
    // Initialize with current state if present in URL
    const urlParams = new URLSearchParams(window.location.search)
    const currentState = urlParams.get('state')
    if (currentState && this.hasSelectTarget) {
      this.selectTarget.value = currentState
    }
  }

  filter() {
    const state = this.selectTarget.value
    const url = new URL(this.urlValue, window.location.href)
    
    if (state) {
      url.searchParams.set("state", state)
    } else {
      url.searchParams.delete("state")
    }

    // Let Turbo handle the full stream response
    Turbo.visit(url.toString())
  }
} 