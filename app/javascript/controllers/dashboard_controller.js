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
    "loading",
    "cards",
    "currentPowerProgressBar",
    "currentMode",
    "outdoorTemperature"
  ]
  static values = { url: String, isLogged: Boolean, currentPower: Number, currentMode: String, outdoorTemperature: Number }

  connect() {
    this.fetchData(this.urlValue);
  }

  /**
   * Get JSON values of Atrea Duplex
   * @param {string} url
   * */
  fetchData(url) {
    fetch(url).then(response => response.json()).then(duplex => {
      this.loadingTarget.style.display = "none"
      this.cardsTarget.style.display = "block"
      console.debug(duplex);
      this.currentPowerValue = duplex.current_power;
      this.currentModeValue = duplex.current_mode;
      this.outdoorTemperatureValue = duplex.outdoor_temperature;
    });
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
