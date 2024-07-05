import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["button"]

  static values = {
    success: { type: String, default: "Copied" },
    successDuration: { type: Number, default: 2000 },
    text: String
  }

  connect() {
    if (this.hasButtonTarget) {
      this.originalValue = this.buttonTarget.innerHTML
    }
  }

  copy(event) {
    if (event) {
      event.preventDefault()
    }

    if (!this.hasTextValue) {
      return
    }

    navigator.clipboard.writeText(this.textValue).then(() => this.complete())
  }

  complete() {
    if (!this.hasButtonTarget || !this.originalValue) {
      return
    }

    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.buttonTarget.innerHTML = this.successValue

    this.timeout = setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalValue
    }, this.successDurationValue)
  }
}
