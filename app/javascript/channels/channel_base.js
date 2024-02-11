export default {
    initialized() {
        console.debug("Channel initialized")
        this.update = this.update.bind(this)
    },

    connected() {
        this.install()
        this.update()
    },

    disconnected() {
        this.uninstall()
    },

    rejected() {
        this.uninstall()
    },

    update() {
        console.debug("Channel update")
        this.documentIsActive ? this.appear() : this.away()
    },

    appear() {
        this.perform("appear", {appearing_on: this.appearingOn})
    },

    away() {
        this.perform("away")
    },

    install() {
        window.addEventListener("focus", this.update)
        window.addEventListener("blur", this.update)
        document.addEventListener("turbo:load", this.update)
        document.addEventListener("visibilitychange", this.update)
    },

    uninstall() {
        window.removeEventListener("focus", this.update)
        window.removeEventListener("blur", this.update)
        document.removeEventListener("turbo:load", this.update)
        document.removeEventListener("visibilitychange", this.update)
    },

    received(data) {
        console.debug("Channel received", data)
    },
    get documentIsActive() {
        return document.visibilityState === "visible" && document.hasFocus()
    },

    get appearingOn() {
        const element = document.querySelector("[data-appearing-on]")
        return element ? element.getAttribute("data-appearing-on") : null
    }
}