import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dismiss"
export default class extends Controller {
  static targets = ["content"]

  connect() {
    setTimeout(() => { this.close(); }, 3000)
  }

  close(event) {
    if (event) {
      event.preventDefault()
    }
    this.contentTarget.addEventListener('transitionend', () => this.contentTarget.remove());
    this.contentTarget.style.opacity = '0'
  }
}

