const difficultySelect = document.getElementById('difficulty-select')
const categorySelect = document.getElementById('category-select')
const nextButton = document.getElementById('go-to-step4-button');

updateButton();

difficultySelect.addEventListener('change', updateButton);
categorySelect.addEventListener('change', updateButton);

function updateButton() {
  nextButton.disabled = difficultySelect.value === '' || categorySelect.value === ''
}

