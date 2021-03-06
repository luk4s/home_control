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
    "preheatTemperature",
    "inputTemperature",
    "preheating",
    "ventilationControls"
  ]
  static values = {
    url: String,
    isLogged: Boolean,
    currentPower: Number,
    currentMode: String,
    outdoorTemperature: Number,
    preheatTemperature: Number,
    inputTemperature: Number,
    preheating: Boolean,
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
  preheatTemperatureValueChanged() {
    this.preheatTemperatureTarget.innerHTML = `${this.preheatTemperatureValue}&#8451;`
  }
  inputTemperatureValueChanged() {
    this.inputTemperatureTarget.innerHTML = `${this.inputTemperatureValue}&#8451;`
  }
  preheatingValueChanged() {
    const locales = JSON.parse(this.preheatingTarget.dataset.values)
    const icon = document.createElement("i")
    icon.className = `fa fa-thermometer-${this.preheatingValue ? "full" : "empty"}`
    this.preheatingTarget.innerHTML = (this.preheatingValue ? locales.enable : locales.disable) + '&nbsp;'
    this.preheatingTarget.classList.toggle("text-danger")
    this.preheatingTarget.appendChild(icon);
  }

  resetControls() {
    this.ventilationControlsTarget.querySelectorAll("a").forEach(i => {
      const name = i.dataset.scenario;
      i.querySelector("span").textContent = this.controlsValue[name].text
      i.querySelector("i").className = `fa fa-${this.controlsValue[name].icon}`
    })
  }

  async scenario(event) {
    event.preventDefault();
    const target = event.currentTarget;
    if (confirm(this.localesValue.confirm)) {
      const response = await patch(target.href)
      if (response.ok) {
        target.querySelector("span").textContent = this.localesValue.disable_with
        target.querySelector("i").className = "fa fa-cog fa-spin"
      }
    }
  }

}
