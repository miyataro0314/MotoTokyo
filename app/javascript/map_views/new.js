let markers = []

initMap(markers);

function initMap(markers) {
  const centerPosition = { lat: 35.6895, lng: 139.6917 };
  const map = new google.maps.Map(document.getElementById('map'), {
    mapId: '<%= Rails.application.credentials.google_maps[:map_id] %>', 
    center: centerPosition,
    zoom: 14,
    gestureHandling: 'greedy',
    disableDefaultUI: true,
    clickableIcons: false
  });

  loadMarkers(map, centerPosition, markers);
  map.addListener('idle', () => updateMarkersDisplay(map));
}

function loadMarkers(map, position, markers) {
  fetch('/api/v1/searches/load_map_data',{
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(position)
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

      setSpotMarkers(map, spots, infoWindow, markers);
      setParkingMarkers(map, parkings, infoWindow, markers);
      updateMarkersDisplay(map);
  }).catch(error => {
    console.log(error);
  })
}

function updateMarkersDisplay(map) {
  markers.forEach(function(marker){
    if(map.getBounds().contains(marker.position)){
      marker.setMap(map);
    }else{
      marker.setMap(null);
    }
  });
}

function setSpotMarkers(map, spots, infoWindow, markers) {
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

function setParkingMarkers(map, parkings, infoWindow, markers) {
  
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

    miniCard.classList.add('slide-out-animation');
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
