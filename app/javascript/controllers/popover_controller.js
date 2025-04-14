import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="popover"
export default class extends Controller {
  static targets = ["box"]

  toggle(event) {
    event.stopPropagation();
    this.boxTarget.classList.toggle("hidden");
  }

  closeAll(event) {
    if (!this.element.contains(event.target)) {
      this.boxTarget.classList.add("hidden");
    }
  }

  connect() {
    document.addEventListener("click", this.closeAll.bind(this));
  }

  disconnect() {
    document.removeEventListener("click", this.closeAll.bind(this));
  }
}


