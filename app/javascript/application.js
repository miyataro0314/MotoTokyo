// Entry point for the build script in your package.json
import '@hotwired/turbo-rails'
import './controllers'

document.addEventListener('turbo:load', () => {
  const flashMessage = document.getElementById('flash');
  if (flashMessage) {
    setTimeout(() => {
      flashMessage.classList.remove('flash');
      flashMessage.classList.add('hidden');
    }, 3500);
  }
});