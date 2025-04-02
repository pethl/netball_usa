// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "./application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import SearchController from "./search_controller"
application.register("search", SearchController)

import StateFilterController from "./state_filter_controller"
application.register("state-filter", StateFilterController)
