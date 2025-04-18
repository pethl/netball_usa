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
import DateFilterController from "./controllers/date_filter_controller"
import EducatorsWizardController from "./controllers/educators_wizard_controller"
import PopoverController from "./controllers/popover_controller"
import PlotlyMapController from "./controllers/plotly_map_controller"
import MobileMenuController from "./controllers/mobile_menu_controller"


const application = Application.start()
application.debug = true // 👈 ADD THIS


// Register all controllers
application.register("vendor-filter", VendorFilterController)
application.register("accordion", AccordionController)  
application.register("filter", FilterController)  
application.register("inline-edit", InlineEditController)  
application.register("page-title", PageTitleController)  
application.register("search", SearchController)
application.register("press-releases", PressReleasesController)
application.register("multi-filter", MultiFilterController)
application.register("date-filter", DateFilterController)
application.register("educators-wizard", EducatorsWizardController)
application.register("popover", PopoverController)
application.register("plotly-map", PlotlyMapController)
application.register("mobile-menu", MobileMenuController)

// Make Stimulus available globally
window.Stimulus = application
console.log("✅ Stimulus + ESBuild initialized")
console.log("Registered controllers:", Object.keys(application.controllers))


