const parkingSelect = document.getElementById('parking-select');
const parkingLimitationSelect = document.getElementById('parking-limitaiton-select');

// 初期表示対応用
if (parkingSelect.value == 'nothing' || parkingSelect.value == 'unknown') {
  parkingLimitationSelect.disabled = true;
}

parkingSelect.addEventListener('change', function() {
  if (this.value == '' || this.value == 'nothing' || this.value == 'unknown') {
    parkingLimitationSelect.value = ''
    parkingLimitationSelect.disabled = true;
  } else {
    parkingLimitationSelect.disabled = false;
  }
});
