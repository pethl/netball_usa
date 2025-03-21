// app/javascript/controllers/filter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "item"]

  connect() {
    console.log("✅ Generic FilterController connected")
  }

  filter() {
    const query = this.inputTarget.value.toLowerCase()

    this.itemTargets.forEach((el) => {
      const text = el.dataset.filterValue?.toLowerCase() || el.textContent.toLowerCase()
      const match = text.includes(query)
      el.style.display = match ? '' : 'none'
    })
  }
}
