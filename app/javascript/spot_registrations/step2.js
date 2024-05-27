const parkingSelect = document.getElementById('parking-select');
const parkingLimitationSelect = document.getElementById('parking-limitaiton-select');
const parkingLimitationDiv = document.getElementById('parking-limitation-div');
const nextButton = document.getElementById('go-to-step3-button');

// 戻るボタン対応用
if (parkingSelect.value !== '' && parkingSelect.value !== 'nothing' && this.value !== 'unknown') {
  parkingLimitationDiv.style.display = 'block';
}
updateButton();

parkingSelect.addEventListener('change', function() {
  if (this.value !== '' && this.value !== 'nothing' && this.value !== 'unknown') {
    parkingLimitationDiv.style.display = 'block';
  } else {
    parkingLimitationDiv.style.display = 'none';
  }
  updateButton();
});

parkingLimitationSelect.addEventListener('change', updateButton);

function updateButton() {
  if (parkingLimitationDiv.style.display === 'block') {
    nextButton.disabled = parkingSelect.value === '' || parkingLimitationSelect.value === ''
  } else {
    nextButton.disabled = parkingSelect.value === ''
  }
}

