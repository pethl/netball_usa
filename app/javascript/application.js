import * as Turbo from "@hotwired/turbo"
window.Turbo = Turbo

import { Application } from "@hotwired/stimulus"
import VendorFilterController from "./controllers/vendor_filter_controller"
import AccordionController from "./controllers/accordion_controller"
import FilterController from "./controllers/filter_controller"
import InlineEditController from "./controllers/inline_edit_controller"
import PageTitleController from "./controllers/page_title_controller"
import SearchController from "./controllers/search_controller"
import PressReleasesController from "./controllers/press_releases_controller"
import MultiFilterController from "./controllers/multi_filter_controller"

const application = Application.start()

// Register all controllers
application.register("vendor-filter", VendorFilterController)
application.register("accordion", AccordionController)  
application.register("filter", FilterController)  
application.register("inline-edit", InlineEditController)  
application.register("page-title", PageTitleController)  
application.register("search", SearchController)
application.register("press-releases", PressReleasesController)
application.register("multi-filter", MultiFilterController)

// Make Stimulus available globally
window.Stimulus = application
console.log("✅ Stimulus + ESBuild initialized")
console.log("Registered controllers:", Object.keys(application.controllers))


