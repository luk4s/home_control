import { readFileSync } from "node:fs"
import { runInNewContext } from "node:vm"
import assert from "node:assert/strict"
import { test } from "node:test"

const controllerSource = readFileSync(new URL("../../app/javascript/controllers/dashboard_controller.js", import.meta.url), "utf8")
  .replace(/^import .*$/gm, "").replace("export default class", "class Dashboard")
const channelSource = readFileSync(new URL("../../app/javascript/channels/duplex_channel.js", import.meta.url), "utf8")
  .replace(/^import .*$/gm, "")

for (const [temperature, expected] of [[null, "—"], [0, "0&#8451;"], [11.1, "11.1&#8451;"]]) {
  test(`channel and dashboard render ${temperature} input temperature`, () => {
    const element = { dataset: {} }
    let channel
    const Dashboard = runInNewContext(`${controllerSource}; Dashboard`, { Controller: class {} })
    runInNewContext(channelSource, {
      base: {}, document: { querySelector: () => element },
      consumer: { subscriptions: { create: (_name, callbacks) => { channel = callbacks } } }
    })
    channel.received({ input_temperature: temperature })
    const dashboard = new Dashboard()
    // Stimulus Number values decode dataset strings using Number().
    dashboard.inputTemperatureValue = Number(String(element.dataset.dashboardInputTemperatureValue))
    dashboard.inputTemperatureTarget = { innerHTML: "" }
    dashboard.inputTemperatureValueChanged()
    assert.equal(dashboard.inputTemperatureTarget.innerHTML, expected)
  })
}
