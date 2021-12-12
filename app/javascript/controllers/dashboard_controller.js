// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
    "cards",
    "currentPowerProgressBar",
    "currentMode",
    "outdoorTemperature"
  ]
  static values = {
    url: String,
    isLogged: Boolean,
    currentPower: Number,
    currentMode: String,
    outdoorTemperature: Number
  }

  connect() {
    this.currentModeTarget.innerHTML = "<i class=\"fa fa-refresh fa-spin fa-2x fa-fw\"></i>Connecting..."
  }

  currentPowerValueChanged() {
    this.currentPowerProgressBarTarget.style.width = `${this.currentPowerValue}%`;
    this.currentPowerProgressBarTarget.textContent = `${this.currentPowerValue}%`;
    this.currentPowerProgressBarTarget.ariaValueNow = this.currentPowerValue;
  }

  currentModeValueChanged() {
    this.currentModeTarget.textContent = this.currentModeValue;
  }

  outdoorTemperatureValueChanged() {
    this.outdoorTemperatureTarget.innerHTML = `${this.outdoorTemperatureValue}&#8451;`
  }
}
