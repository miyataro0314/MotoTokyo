initMap();

function initMap() {
  // Mapの用意
  const centerPosition = { lat: 35.6895, lng: 139.6917 };
  const map = new google.maps.Map(document.getElementById('map'), {
    mapId: '<%= Rails.application.credentials.google_maps[:map_id] %>', 
    center: centerPosition,
    zoom: 12,
    gestureHandling: 'greedy'
  });

  reloadMarkers(map, centerPosition);
}

// マップ移動時に動的にマーカー更新
function reloadMarkers(map, position) {
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

      setSpotMarkers(map, spots);
      setParkingMarkers(map, parkings);
  }).catch(error => {
    console.log(error);
  })
}

function setSpotMarkers(map, spots) {
  spots.forEach((spot, i) => {
    setTimeout(() => {
      const regex = /POINT \(([0-9]+.[0-9]+) ([0-9]+.[0-9]+)\)/;
      const match = spot.spot_detail.coordinate.match(regex);
      const spotPosition = { lat: parseFloat(match[2]),
                            lng: parseFloat(match[1]) };
      const spotMarker = new google.maps.marker.AdvancedMarkerElement({
        map,
        position: spotPosition,
        title: spot.name
      });

      const infoWindow = new google.maps.InfoWindow();

      google.maps.event.addListener(spotMarker, "click", (function(marker, name) {
        return function() {
          infoWindow.close();
          infoWindow.setContent(name);
          infoWindow.open(map, marker);
        };
      })(spotMarker, spot.name));
    }, i * 10);
  });
}

function setParkingMarkers(map, parkings) {
  
  parkings.forEach((parking, i) => {
    setTimeout(() => {
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
        map,
        position: parkingPosition,
        content: blueMarker.element
      });

      const infoWindow = new google.maps.InfoWindow();
        
      google.maps.event.addListener(parkingMarker, "click", (function(marker, name) {
        return function() {
          infoWindow.close();
          infoWindow.setContent(name);
          infoWindow.open(map, marker);
        };
      })(parkingMarker, parking.name));
    }, i * 5);
  });
}
