// app/javascript/controllers/educators_wizard_controller.js

import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="educators-wizard"
export default class extends Controller {
  static targets = ["modal", "eventSelect"];

  connect() {
    console.log("✅ EducatorsWizardController connected!");
  }

  open() {
    console.log("🔵 open() action triggered!");
    if (this.hasModalTarget) {
      console.log("🟢 modalTarget found:", this.modalTarget);
      this.modalTarget.style.display = "block";
    } else {
      console.log("🔴 modalTarget missing!");
    }
  }

  close() {
    console.log("🟠 Closing modal...");
    if (this.hasModalTarget) {
      this.modalTarget.style.display = "none";
    }
  }

  associate(event) {
    event.preventDefault(); 
    console.log("🟣 associate() action triggered!");
  
    const eventId = this.eventSelectTarget.value;
    const educatorIds = [...document.querySelectorAll('.educator-checkbox:checked')].map(cb => cb.value);
  
    console.log("Selected Event ID:", eventId);
    console.log("Selected Educator IDs:", educatorIds);
  
    fetch(`/events/${eventId}/assign_educators`, { // ← NO locale
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        educator_ids: educatorIds
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        console.log("✅ Educators associated successfully!");
        alert('Educators associated successfully!');
        this.close();
      } else {
        console.error("❌ Association failed:", data);
        alert('Association failed.');
      }
    })
    .catch(error => {
      console.error("❌ Network error:", error);
      alert('An error occurred.');
    });
  }
}

