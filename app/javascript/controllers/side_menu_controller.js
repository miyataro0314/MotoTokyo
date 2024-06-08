import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['background', 'menu'];

  connect() {
    document.body.classList.add('no-scroll')
  }

  closeMenu(event) {
    if (event.target === this.backgroundTarget) {
      if (this.menuTarget.classList.contains('contract-menu-animation')) {
        this.menuTarget.classList.remove('contract-menu-animation');
      }
      if (this.menuTarget.classList.contains('expand-menu-animation')) {
        this.menuTarget.classList.remove('expand-menu-animation');
      }

      this.menuTarget.classList.add('end-menu-animation');
      this.backgroundTarget.classList.add('end-bg-animation');
      this.backgroundTarget.classList.remove('z-50');

      this.menuTarget.addEventListener('animationend', () => {
        this.menuTarget.style.display = 'none';
      }, { once: true });
      this.backgroundTarget.addEventListener('animationend', () => {
        this.backgroundTarget.style.display = 'none';
      }, { once: true });

      document.body.classList.remove('no-scroll')
    }
  }
}
