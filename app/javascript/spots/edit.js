const parkingSelect = document.getElementById('parking-select');
const parkingLimitationSelect = document.getElementById('parking-limitaiton-select');

parkingSelect.addEventListener('change', function() {
  if (this.value == '' || this.value == 'nothing') {
    parkingLimitationSelect.value = ''
    parkingLimitationSelect.disabled = true;
  } else {
    parkingLimitationSelect.disabled = false;
  }
});