import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["vendor", "checkbox"]

  connect() {
    console.log("✅ VendorFilterController connected!")
  }

  filter() {
    const selected = this.checkboxTargets
      .filter(cb => cb.checked)
      .map(cb => cb.value)

    console.log("Selected categories:", selected)
    console.log("Found vendor targets:", this.vendorTargets.length)

    this.vendorTargets.forEach((vendor) => {
      const categories = (vendor.dataset.categories || "")
        .split(",")
        .map(cat => cat.trim())

      const show = selected.length === 0 || selected.some(cat => categories.includes(cat))
      vendor.style.display = show ? '' : 'none'
    })
  }
}
