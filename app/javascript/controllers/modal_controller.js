import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['background', 'modal'];

  connect() {
    document.body.classList.add('no-scroll')
    this.openModal();
  }

  openModal() {
    this.modalTarget.classList.add('start-modal-animation');
    this.backgroundTarget.classList.add('start-bg-animation');
  }

  closeModal(event) {
    if (event.target === this.backgroundTarget) {
      if (this.modalTarget.classList.contains('contract-modal-animation')) {
        this.modalTarget.classList.remove('contract-modal-animation');
      }
      if (this.modalTarget.classList.contains('expand-modal-animation')) {
        this.modalTarget.classList.remove('expand-modal-animation');
      }

      this.modalTarget.classList.add('end-modal-animation');
      this.backgroundTarget.classList.add('end-bg-animation');
      this.backgroundTarget.classList.remove('z-50');

      this.modalTarget.addEventListener('animationend', () => {
        this.modalTarget.style.display = 'none';
      }, { once: true });
      this.backgroundTarget.addEventListener('animationend', () => {
        this.backgroundTarget.style.display = 'none';
      }, { once: true });

      document.body.classList.remove('no-scroll')
    }
  }

  closeModalBySubmit() {
    this.modalTarget.classList.add('end-modal-animation');
    this.backgroundTarget.classList.add('end-bg-animation');
    this.backgroundTarget.classList.remove('z-50');

    this.modalTarget.addEventListener('animationend', () => {
      this.modalTarget.style.display = 'none';
    }, { once: true });
    this.backgroundTarget.addEventListener('animationend', () => {
      this.backgroundTarget.style.display = 'none';
    }, { once: true });

    document.body.classList.remove('no-scroll')
  }
}
