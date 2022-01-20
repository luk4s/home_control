// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import { patch } from '@rails/request.js'

export default class extends Controller {
  static targets = [
    "cards",
    "currentPowerProgressBar",
    "currentMode",
    "outdoorTemperature",
    "ventilationControls"
  ]
  static values = {
    url: String,
    isLogged: Boolean,
    currentPower: Number,
    currentMode: String,
    outdoorTemperature: Number,
    controls: Object,
    locales: Object
  }

  connect() {
    this.currentModeTarget.innerHTML = "<i class=\"fa fa-refresh fa-spin fa-2x fa-fw\"></i>Connecting..."
  }

  currentPowerValueChanged() {
    this.currentPowerProgressBarTarget.style.width = `${this.currentPowerValue}%`;
    this.currentPowerProgressBarTarget.textContent = `${this.currentPowerValue}%`;
    this.currentPowerProgressBarTarget.ariaValueNow = this.currentPowerValue;
    this.resetControls();
  }

  currentModeValueChanged() {
    this.currentModeTarget.textContent = this.currentModeValue;
    this.resetControls();
  }

  outdoorTemperatureValueChanged() {
    this.outdoorTemperatureTarget.innerHTML = `${this.outdoorTemperatureValue}&#8451;`
  }

  resetControls() {
    this.ventilationControlsTarget.querySelectorAll("a").forEach(i => {
      i.querySelector("span").textContent = this.controlsValue[i.dataset.scenario]
    })
  }

  async scenario(event) {
    event.preventDefault();
    const target = event.currentTarget;
    if (confirm(this.localesValue.confirm)) {
      const response = await patch(target.href)
      if (response.ok) {
        target.querySelector("span").textContent = this.localesValue.disable_with
      }
    }

  }
}
