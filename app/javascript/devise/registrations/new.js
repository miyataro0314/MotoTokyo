const userIdForm = document.getElementById('user_id');
const emailForm = document.getElementById('user_email');
const passwordForm = document.getElementById('user_password');
const passwordConfirmationForm = document.getElementById('user_password_confirmation');
const checkBox = document.getElementById('check');
const submitButton = document.getElementById('submit');

function validateForm() {
  const isFormValid =
    userIdForm.value.trim() !== '' &&
    emailForm.value.trim() !== '' &&
    passwordForm.value.trim() !== '' &&
    passwordConfirmationForm.value.trim() !== '' &&
    checkBox.checked;

  submitButton.disabled = !isFormValid;
}

userIdForm.addEventListener('input', validateForm);
emailForm.addEventListener('input', validateForm);
passwordForm.addEventListener('input', validateForm);
passwordConfirmationForm.addEventListener('input', validateForm);
checkBox.addEventListener('change', validateForm);

validateForm();