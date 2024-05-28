import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ['flashMessage']

  connect() {
  }

  endFlash() {
    this.flashMessageTarget.classList.remove('start-flash-animation');
    this.flashMessageTarget.classList.add('end-flash-animation');
  }
}
