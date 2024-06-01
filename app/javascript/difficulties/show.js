const difficultySelect = document.getElementById('difficulty-select');
const submitButton = document.getElementById('submit-button');

// 初期表示対応用
if (difficultySelect.value == '') {
  submitButton.disabled = true;
}

difficultySelect.addEventListener('change', function() {
  if (this.value == '') {
    submitButton.disabled = true;
  } else {
    submitButton.disabled = false;
  }
});