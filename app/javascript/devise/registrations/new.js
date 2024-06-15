import debounce from 'lodash/debounce'

const userIdForm = document.getElementById('user_id');
const emailForm = document.getElementById('user_email');
const passwordForm = document.getElementById('user_password');
const confirmationForm = document.getElementById('user_password_confirmation');
const checkBox = document.getElementById('check');
const submitButton = document.getElementById('submit');

let isIdValid = false;
let isEmailValid = false;
let isPasswordValid = false;
let isConfirmationValid = false;

validateForm();

function validateForm() {
  const isFormValid =
    isIdValid && isEmailValid &&
    isPasswordValid && isConfirmationValid &&
    checkBox.checked;

  submitButton.disabled = !isFormValid;
}

function handleUserIdInput() {
  clearResult('id-check-result')
  const inputValue = userIdForm.value
  const pattern = /^[a-zA-Z0-9]{6,}$/;

  if (pattern.test(inputValue)) {
    fetch('/api/v1/user_registrations/check_id',{
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 'id': inputValue })
    }).then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    }).then(data => {
      if (data.available) {
        displayInfo('id-check-result', 'このユーザーIDは利用可能です');
        isIdValid = true
      } else {
        displayInfo('id-check-result', '既に使用されています');
        isIdValid = false
      } 
    }).catch(error => {
      console.log(error)
    })
  } else {
    displayInfo('id-check-result', '半角英数字6文字以上で入力してください');
  }
  validateForm();
};

function handleEmailInput() {
  const inputValue = emailForm.value
  clearResult('email-check-result')

  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  if (emailPattern.test(inputValue)) {
    fetch('/api/v1/user_registrations/check_email',{
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 'email': inputValue })
    }).then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();
    }).then(data => {
      if (data.available) {
        displayInfo('email-check-result', 'このメールアドレスは利用可能です');
        isEmailValid = true
      } else {
        displayInfo('email-check-result', '既に使用されています');
        isEmailValid = false
      } 
    }).catch(error => {
      console.log(error)
    })
  } else {
    clearResult('email-check-result')
  }
  validateForm();
};

function handlePasswordInput() {
  clearResult('password-check-result')

  const password = passwordForm.value
  const confirmation = confirmationForm.value
  const pattern = /^[a-zA-Z0-9]{6,}$/;

  if (pattern.test(password)) {
    clearResult('password-check-result')
    isPasswordValid = true
    if (confirmation) { handleConfirmationInput() }
  } else {
    displayInfo('password-check-result', '半角英数字6文字以上で入力してください')
    isPasswordValid = false
  }
  validateForm();
}

function handleConfirmationInput() {
  clearResult('confirmation-check-result')

  const password = passwordForm.value
  const confirmation = confirmationForm.value

  if (password === confirmation) {
    clearResult('confirmation-check-result')
    isConfirmationValid = true
  } else {
    displayInfo('confirmation-check-result', 'パスワードが一致しません')
    isConfirmationValid = false
  }
  validateForm();
}

const displayInfo = (target, info) => {
  const targetElement = document.getElementById(target)
  const infoDiv = document.createElement('div');
  
  infoDiv.classList.add('mt-2', 'text-primary-content', 'text-xs');
  infoDiv.textContent = info;
  
  targetElement.appendChild(infoDiv);
};

const clearResult = (target) => {
  const parentElement = document.getElementById(target);
  while (parentElement.firstChild) {
    parentElement.removeChild(parentElement.firstChild);
  }
};

userIdForm.addEventListener('input', debounce(handleUserIdInput, 300));
emailForm.addEventListener('input', debounce(handleEmailInput, 300));
passwordForm.addEventListener('input', debounce(handlePasswordInput, 300));
confirmationForm.addEventListener('input', debounce(handleConfirmationInput, 300));
checkBox.addEventListener('change', validateForm);
