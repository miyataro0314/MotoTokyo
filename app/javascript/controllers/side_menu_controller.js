import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['background', 'menuLeft', 'menuRight'];

  connect() {
    document.body.classList.add('no-scroll')
    if (this.hasMenuLeftTarget) {
      this.openMenuLeft();
    } else if (this.hasMenuRightTarget) {
      this.openMenuRight();
    }
  }

  openMenuLeft() {
    this.menuLeftTarget.classList.add('start-menu-left-animation');
    this.backgroundTarget.classList.add('start-bg-animation');
  }

  openMenuRight() {
    this.menuRightTarget.classList.add('start-menu-right-animation');
    this.backgroundTarget.classList.add('start-bg-animation');
  }
  
  closeMenuLeft(event) {
    if (event.target === this.backgroundTarget) {
      this.menuLeftTarget.classList.add('end-menu-left-animation');
      this.backgroundTarget.classList.add('end-bg-animation');
      this.backgroundTarget.classList.remove('z-50');

      this.menuLeftTarget.addEventListener('animationend', () => {
        this.menuLeftTarget.style.display = 'none';
      }, { once: true });
      this.backgroundTarget.addEventListener('animationend', () => {
        this.backgroundTarget.style.display = 'none';
      }, { once: true });

      document.body.classList.remove('no-scroll')
    }
  }

  closeMenuLeftByButton() {
    this.menuLeftTarget.classList.add('end-menu-left-animation');
    this.backgroundTarget.classList.add('end-bg-animation');
    this.backgroundTarget.classList.remove('z-50');

    this.menuLeftTarget.addEventListener('animationend', () => {
      this.menuLeftTarget.style.display = 'none';
    }, { once: true });
    this.backgroundTarget.addEventListener('animationend', () => {
      this.backgroundTarget.style.display = 'none';
    }, { once: true });

    document.body.classList.remove('no-scroll')
  }

  closeMenuRight(event) {
    if (event.target === this.backgroundTarget) {
      this.menuRightTarget.classList.add('end-menu-right-animation');
      this.backgroundTarget.classList.add('end-bg-animation');
      this.backgroundTarget.classList.remove('z-50');

      this.menuRightTarget.addEventListener('animationend', () => {
        this.menuRightTarget.style.display = 'none';
      }, { once: true });
      this.backgroundTarget.addEventListener('animationend', () => {
        this.backgroundTarget.style.display = 'none';
      }, { once: true });

      document.body.classList.remove('no-scroll')
    }
  }

  closeMenuRightByButton() {
    this.menuRightTarget.classList.add('end-menu-right-animation');
    this.backgroundTarget.classList.add('end-bg-animation');
    this.backgroundTarget.classList.remove('z-50');

    this.menuRightTarget.addEventListener('animationend', () => {
      this.menuRightTarget.style.display = 'none';
    }, { once: true });
    this.backgroundTarget.addEventListener('animationend', () => {
      this.backgroundTarget.style.display = 'none';
    }, { once: true });

    document.body.classList.remove('no-scroll')
  }
}
