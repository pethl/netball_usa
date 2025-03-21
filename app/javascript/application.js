import { Application } from "@hotwired/stimulus"
import VendorFilterController from "./controllers/vendor_filter_controller"
import AccordionController from "./controllers/accordion_controller"

const application = Application.start()
application.register("vendor-filter", VendorFilterController)
application.register("accordion", AccordionController)


console.log("✅ Stimulus + ESBuild initialized")


