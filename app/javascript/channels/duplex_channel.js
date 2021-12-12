import consumer from "./consumer"

consumer.subscriptions.create("DuplexChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const controller = document.querySelector('div[data-controller="dashboard"]')
    if (data && controller) {
      controller.dataset.dashboardCurrentModeValue = data["current_mode"]
      controller.dataset.dashboardCurrentPowerValue = data["current_power"]
      controller.dataset.dashboardOutdoorTemperatureValue = data["outdoor_temperature"]
    }
    // Called when there's incoming data on the websocket for this channel
  }
});
