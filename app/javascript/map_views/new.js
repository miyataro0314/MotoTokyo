let markers = []
const searchButton = document.getElementById('search-button')
const searchBoard = document.getElementById('search-board')

const centerPosition = { lat: 35.6895, lng: 139.6917 };
const map = new google.maps.Map(document.getElementById('map'), {
  mapId: '<%= Rails.application.credentials.google_maps[:map_id] %>', 
  center: centerPosition,
  zoom: 14,
  gestureHandling: 'greedy',
  disableDefaultUI: true,
  clickableIcons: false
});

initSearchComponents();

loadMarkers();
map.addListener('idle', () => {
  animateSearchComponents();
  updateMarkersDisplay(map);
});


function loadMarkers(query) {
  clearMarkers();

  const requestBody = JSON.stringify({
    query: query ? query : { query: false }
  });

  fetch('/api/v1/map_views/fetch_map_data',{
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: requestBody
  }).then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();  // JSON形式でレスポンスボディを解析
  }).then(data => {
      const spots = data.spots;
      const parkings = data.parkings;
      const infoWindow = new google.maps.InfoWindow();
      infoWindow.addListener('closeclick', closeMiniCard);

      setSpotMarkers(spots, infoWindow);
      setParkingMarkers(parkings, infoWindow);
      updateMarkersDisplay(map);
  }).catch(error => {
    console.log(error);
  })
}

function clearMarkers() {
  for (let i = 0; i < markers.length; i++) {
    markers[i].setMap(null);
  }

  markers = [];
}

function updateMarkersDisplay() {
  markers.forEach(function(marker){
    if(map.getBounds().contains(marker.position)){
      marker.setMap(map);
    }else{
      marker.setMap(null);
    }
  });
}

function setSpotMarkers(spots, infoWindow) {
  spots.forEach((spot, i) => {
    const regex = /POINT \(([0-9]+.[0-9]+) ([0-9]+.[0-9]+)\)/;
    const match = spot.spot_detail.coordinate.match(regex);
    const spotPosition = { lat: parseFloat(match[2]),
                          lng: parseFloat(match[1]) };
    const spotMarker = new google.maps.marker.AdvancedMarkerElement({
      position: spotPosition,
      title: spot.name
    });

    spotMarker.addListener('gmp-click', (function(id, name, marker) {
      return function() {
        infoWindow.setContent(name);
        infoWindow.open(map, marker);
        closeMiniCard(() => fetchSpot(id));
      };
    })(spot.id, spot.name, spotMarker));

    markers.push(spotMarker)
  });
}

function setParkingMarkers(parkings, infoWindow) {
  
  parkings.forEach((parking, i) => {
    const regex = /POINT \(([0-9]+.[0-9]+) ([0-9]+.[0-9]+)\)/;
    const match = parking.coordinate.match(regex);
    const parkingPosition = { lat: parseFloat(match[2]),
                              lng: parseFloat(match[1]) };
    const blueMarker = new google.maps.marker.PinView({
      background: "#1b73e8",
      borderColor: "#0b4087",
      glyphColor: "#0b4087"
    });

    parkingMarker = new google.maps.marker.AdvancedMarkerElement({
      position: parkingPosition,
      content: blueMarker.element
    });

    parkingMarker.addListener('gmp-click', (function(id, name, marker) {
      return function() {
        infoWindow.setContent(name);
        infoWindow.open(map, marker);
        closeMiniCard(() => fetchParking(id));
      }
    })(parking.id, parking.name, parkingMarker));

    markers.push(parkingMarker)
  });
}

function closeMiniCard(callback) {
  const miniCard = document.getElementById('mini-card')

  if (miniCard) {
    const removeMiniCard = () => {
      miniCard.removeEventListener('animationend', removeMiniCard);
      miniCard.remove();
      if (typeof callback === 'function') {
        callback();
      }
    };

    miniCard.classList.add('slide-down-animation');
    miniCard.addEventListener('animationend', removeMiniCard);
  } else {
    if (typeof callback === 'function') {
      callback();
    }
  }
}

function fetchSpot(id) {
  fetch(`/map_views/spot_mini_card/${id}`,{
    method: 'GET',
    headers: {
      accept: 'text/vnd.turbo-stream.html'
    }
  }).then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.text();
  })
  .then(turboStreamHTML => {
    Turbo.renderStreamMessage(turboStreamHTML);
  })
  .catch(error => {
    console.error('Fetch operation failed:', error);
  });
}

function fetchParking(id) {
  fetch(`/map_views/parking_mini_card/${id}`,{
    method: 'GET',
    headers: {
      accept: 'text/vnd.turbo-stream.html'
    }
  }).then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.text();
  })
  .then(turboStreamHTML => {
    Turbo.renderStreamMessage(turboStreamHTML);
  })
  .catch(error => {
    console.error('Fetch operation failed:', error);
  });
}

function initSearchComponents() {
  const searchForm = document.getElementById('search-form');

  searchButton.addEventListener('click', () => {
    if (searchBoard.classList.contains('slide-up-animation')) {
      searchBoard.classList.remove('slide-up-animation');
    }
    searchBoard.classList.add('slide-down-animation');
    
    if (searchButton.classList.contains('slide-right-animation')) {
      searchButton.classList.remove('slide-right-animation');
    }
    searchButton.classList.add('slide-left-animation');
  })

  searchForm.addEventListener('input', () => {
    const formData = new FormData(searchForm)
    const queryObject = {}
    
    for (const [key, value] of formData.entries()) {
      queryObject[key] = value;
    }
  
    loadMarkers(queryObject);
  })
}

function animateSearchComponents() {
  if (searchBoard.classList.contains('slide-down-animation')) {
    searchBoard.classList.remove('slide-down-animation')
    searchBoard.classList.add('slide-up-animation')
    searchButton.classList.remove('slide-left-animation')
    searchButton.classList.add('slide-right-animation')
  }
}