import { Application } from "@hotwired/stimulus"
import VendorFilterController from "./controllers/vendor_filter_controller"

const application = Application.start()
application.register("vendor-filter", VendorFilterController)

console.log("✅ Stimulus + ESBuild initialized")


