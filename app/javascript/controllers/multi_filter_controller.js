import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["field"]
  static values = {
    url: String
  }

  connect() {
    console.log("MultiFilter connected")
    this.timeout = null

    const urlParams = new URLSearchParams(window.location.search)
    this.fieldTargets.forEach(field => {
      const currentValue = urlParams.get(field.name)
      if (currentValue) {
        field.value = currentValue
      }
    })
  }

  filter() {
    console.log("Filter triggered")

    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      const url = new URL(this.urlValue, window.location.href)

      this.fieldTargets.forEach(field => {
        url.searchParams.delete(field.name)
      })

      this.fieldTargets.forEach(field => {
        if (field.value.trim() !== "") {
          url.searchParams.set(field.name, field.value.trim())
        }
      })

      console.log("Navigating to:", url.toString())
      window.location.href = url.toString()
    }, 300)
  }
}
