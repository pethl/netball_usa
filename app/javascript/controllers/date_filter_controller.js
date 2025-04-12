import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String
  }

  // Function to filter by the selected date
  filterByDate(event) {
    const selectedDate = event.target.value; // Get the selected date from the input
    const url = new URL(this.urlValue, window.location.origin)

    // Set or remove the date filter parameter in the URL
    if (selectedDate) {
      url.searchParams.set("created_at", selectedDate); // Set the created_at parameter
    } else {
      url.searchParams.delete("created_at"); // Remove the created_at parameter if no date is selected
    }

    // Use Turbo to visit the updated URL
    Turbo.visit(url.toString()); // This triggers the page reload with the filtered results
  }
}
