import { Application } from "@hotwired/stimulus"
import VendorFilterController from "./controllers/vendor_filter_controller"
import AccordionController from "./controllers/accordion_controller"
import FilterController from "./controllers/filter_controller"


const application = Application.start()
application.register("vendor-filter", VendorFilterController)
application.register("accordion", AccordionController)  
application.register("filter", FilterController)  


console.log("✅ Stimulus + ESBuild initialized")


