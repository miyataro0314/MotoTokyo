const postcodeInput = document.getElementById('postcode-input')
const addressInput = document.getElementById('address-input')

// オートコンプリート候補選択時のイベントリスナー
postcodeInput.addEventListener('input', (event) => {
  let inputValue = event.target.value;

  if (inputValue.length === 7) {
    let postcode = inputValue

    fetch(`https://postcode.teraren.com/postcodes/${postcode}.json`,{
      method: 'GET',
    }).then(response => {
      if (!response.ok) { 
        throw new Error('Network response was not ok');
      }
      return response.json();
    }).then(data => {
      const addressParts = [];

      if (data.city) addressParts.push(data.city);
      if (data.suburb) addressParts.push(data.suburb);
      if (data.street_address) addressParts.push(data.street_address);

      const address = addressParts.join('');

      addressInput.value = address
    }).catch(error => {
      console.log(error)
    })
  }
})