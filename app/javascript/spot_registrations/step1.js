// Autocomplete実装のための関数
window.initAutocomplete = () => {
  // 東京全域（離島を除く）を全て囲む範囲の設定
  const tokyoBounds = new google.maps.LatLngBounds(
    new google.maps.LatLng(35.446798, 138.964089),
    new google.maps.LatLng(35.893411, 139.921124)
  );
  
  // テキスト入力フィールドにオートコンプリートを適用
  const autocomplete = new google.maps.places.Autocomplete(
    document.getElementById('place-autocomplete-input'), {
      types: ['establishment'],
      bounds: tokyoBounds,
      strictBounds: true
    }
  );
  
  // レスポンスデータの指定
  autocomplete.setFields(['name', 'adr_address', 'current_opening_hours', 'formatted_phone_number', 'place_id', 'rating', 'user_ratings_total', 'url', 'geometry']);
  
  // オートコンプリート候補選択時のイベントリスナー
  autocomplete.addListener('place_changed', () => {
    let place = autocomplete.getPlace();
    
    clearDivs();
    
    fetch('/api/v1/spots/check',{
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(place)
    }).then(response => {
      if (!response.ok) {
        throw new Error('Network response was not ok');
      }
      return response.json();  // JSON形式でレスポンスボディを解析
    }).then(data => {
      if (data.available) {
        sessionStorage.setItem('placeName', place.name)
        displayPlaceName(place.name);
        displayInfo('このスポットは登録可能です');
        nextButton.disabled = false;
      } else if (data.reason === 'already_registered') {
        displayInfo('このスポットは既に登録されています');
      } else if (data.reason === 'out_of_area') {
        displayInfo('このスポットはエリア範囲外です');
        displayInfo('（東京都内スポットのみ登録可能）')
      }
    }).catch(error => {
      console.log(error)
    }
  )
});
}

const displayPlaceName = (name) => {
  const target = document.getElementById('place-check-result');
  const nameDiv = document.createElement('div');
  
  nameDiv.setAttribute('name', 'name-div');
  nameDiv.classList.add('name-div', 'mt-3', 'text-primary-content', 'text-base', 'font-semibold');
  nameDiv.innerHTML = `スポット名：<br>${name}`;
  
  target.appendChild(nameDiv);
};

const displayInfo = (info) => {
  const target = document.getElementById('place-check-result');
  const infoDiv = document.createElement('div');
  
  infoDiv.setAttribute('name', 'info-div');
  infoDiv.classList.add('info-div', 'mt-2', 'text-primary-content', 'text-sm');
  infoDiv.textContent = info;
  
  target.appendChild(infoDiv);
};

const clearDivs = () => {
  const target = document.getElementById('place-check-result');
  const divs = document.querySelectorAll('div[name=name-div], div[name=info-div]');
  
  if (divs.length) {
    divs.forEach(div => {
      target.removeChild(div);
    });
  }
};

// --- 初期化処理 ---
const placeName = sessionStorage.getItem('placeName')
const nextButton = document.getElementById('go-to-step2-button');

// 戻るボタン、モーダル再オープン時に対応
if (placeName) {
  displayPlaceName(placeName);
  displayInfo('このスポットは登録可能です');
  nextButton.disabled = false;
} 
//-------------------

// --- GoogleMapAPI ---
initAutocomplete();
//---------------------