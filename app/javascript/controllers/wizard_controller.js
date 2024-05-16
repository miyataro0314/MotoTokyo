import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="wizard"
export default class extends Controller {
  static targets = ['contents', 'next', 'back', 'input', 'toRegistration']

  connect() {
    const transitionType = sessionStorage.getItem('transitionType');
    
    if (transitionType === 'next') {
      this.contentsTarget.classList.add('slide-from-right-animation');
    }
    else if (transitionType === 'back') {
      this.contentsTarget.classList.add('slide-from-left-animation');
    }
    sessionStorage.removeItem('transitionType')
  }

  next(event) {
    if (event.target === this.nextTarget) {
      sessionStorage.setItem('transitionType', 'next');
    }
  }

  back(event) {
    if (event.target === this.backTarget) {
      sessionStorage.setItem('transitionType', 'back');
    }
  }

  removeSessionStorage() {
    sessionStorage.removeItem('placeName')
  }
}