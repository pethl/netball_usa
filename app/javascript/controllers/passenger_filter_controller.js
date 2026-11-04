import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  filter() {
    const query = this.inputTarget.value.trim().toLowerCase()

    this.rowTargets.forEach((row) => {
      row.classList.toggle("hidden", !row.dataset.passengerName.includes(query))
    })
  }
}
