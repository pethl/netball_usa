// app/javascript/application.js
import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"

// ✅ Import and register controllers manually
import FilterController from "./controllers/vendor_filter_controller"

const application = Application.start()
application.register("vendor-filter", VendorFilterController)

console.log("✅ Stimulus + ESBuild initialized")

