console.log("Loading multi_filter_controller.js")

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]
  static values = {
    url: String
  }

  connect() {
    console.log("MultiFilter connected")
    // Initialize with current values if present in URL
    const urlParams = new URLSearchParams(window.location.search)
    this.selectTargets.forEach(select => {
      const currentValue = urlParams.get(select.name)
      if (currentValue) {
        select.value = currentValue
      }
    })
  }

  filter() {
    console.log("Filter triggered")
    const url = new URL(this.urlValue, window.location.href)
    
    // Clear all existing filter params
    this.selectTargets.forEach(select => {
      url.searchParams.delete(select.name)
    })

    // Add only the non-empty filter values
    this.selectTargets.forEach(select => {
      if (select.value) {
        url.searchParams.set(select.name, select.value)
      }
    })

    console.log("Navigating to:", url.toString())
    window.location.href = url.toString()
  }
} 