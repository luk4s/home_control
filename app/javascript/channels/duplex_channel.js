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
      controller.dataset.dashboardPreheatTemperatureValue = data["preheat_temperature"]
      controller.dataset.dashboardInputTemperatureValue = data["input_temperature"]
      controller.dataset.dashboardPreheatingValue = data["preheating"]

      // if (window.chart) {
      //   const t = new Date()
      //   data = {"current_power": 95}
      //   const label = `${t.getHours()}:${t.getMinutes()}`
      //   window.chart.data.labels.push(label);
      //   chart.data.datasets.forEach((dataset) => {
      //     dataset.data.push({ x: label, y: data["current_power"] });
      //   });
      //   chart.update();
      // }

    }
    // Called when there's incoming data on the websocket for this channel
  }
});
