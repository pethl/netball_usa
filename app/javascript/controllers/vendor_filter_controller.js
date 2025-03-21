import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["vendor", "checkbox"]

  connect() {
    console.log("✅ FilterController connected!")
  }

  filter() {
    console.log("🔍 Filtering triggered")
    console.log("Found vendor targets:", this.vendorTargets.length)

    const selected = this.checkboxTargets
      .filter(cb => cb.checked)
      .map(cb => cb.value)

    console.log("Selected categories:", selected)

    this.vendorTargets.forEach((vendor) => {
      const vendorCategories = (vendor.dataset.categories || "")
        .split(",")
        .map(cat => cat.trim())
        .filter(Boolean)

      console.log("Vendor categories:", vendorCategories)

      const hasMatch = selected.length === 0 || selected.some(cat => vendorCategories.includes(cat))

      // 💥 This works more reliably for table rows
      vendor.style.display = hasMatch ? '' : 'none'
    })
  }
}

