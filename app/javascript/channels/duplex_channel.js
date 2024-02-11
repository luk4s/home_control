import consumer from "./consumer"
import base from "./channel_base"

consumer.subscriptions.create("DuplexChannel", Object.assign(base, {
    received(data) {
        document.addEventListener("turbo:load", () => {
            this.updateStimulusController(data)
        })
        this.updateStimulusController(data)
    },
    updateStimulusController(data) {
        const controller = document.querySelector('div[data-controller="dashboard"]')
        if (data && controller) {
            controller.dataset.dashboardCurrentModeValue = data[ "current_mode" ]
            controller.dataset.dashboardCurrentPowerValue = data[ "current_power" ]
            controller.dataset.dashboardOutdoorTemperatureValue = data[ "outdoor_temperature" ]
            controller.dataset.dashboardPreheatTemperatureValue = data[ "preheat_temperature" ]
            controller.dataset.dashboardInputTemperatureValue = data[ "input_temperature" ]
            controller.dataset.dashboardPreheatingValue = data[ "preheating" ]
        }
    }

}));
