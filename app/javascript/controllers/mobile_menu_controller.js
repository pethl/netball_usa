import { Controller } from "@hotwired/stimulus"
console.log("📦 mobile_menu_controller.js is being compiled")

export default class extends Controller {
  static targets = ["menu"]


  connect() {
    console.log("✅ mobile-menu controller connected")
  }

  toggle() {
    console.log("🍔 Toggle called")
    this.menuTarget.classList.toggle("hidden")
  }
}

