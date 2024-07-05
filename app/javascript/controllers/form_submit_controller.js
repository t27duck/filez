import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form-submit"
export default class extends Controller {
  submit(event) {
    if (event) {
      event.preventDefault()
    }

    this.element.requestSubmit()
  }
}
