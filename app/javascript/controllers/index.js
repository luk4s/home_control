import { Application } from "@hotwired/stimulus"
import DashboardController from "./dashboard_controller"

window.Stimulus = Application.start()
Stimulus.register("dashboard", DashboardController)