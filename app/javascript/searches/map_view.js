initMap();

function initMap() {
  const centerPosition = { lat: 35.6895, lng: 139.6917 };
  const map = new google.maps.Map(document.getElementById('map'), {
    mapId: '<%= Rails.application.credentials.google_maps[:map_id] %>', 
    center: centerPosition,
    zoom: 12,
    gestureHandling: 'greedy'
  });

  reloadMarkers(map, centerPosition);
}

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
      const infoWindow = new google.maps.InfoWindow();

      setSpotMarkers(map, spots, infoWindow);
      setParkingMarkers(map, parkings, infoWindow);
  }).catch(error => {
    console.log(error);
  })
}

function setSpotMarkers(map, spots, infoWindow) {
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

      spotMarker.addListener('click', (function(name, marker) {
        return function() {
          infoWindow.setContent(name);
          infoWindow.open(map, marker);
        };
      })(spot.name, spotMarker));
    }, i * 10);
  });
}

function setParkingMarkers(map, parkings, infoWindow) {
  
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
        
      parkingMarker.addListener('click', (function(name, marker) {
        return function() {
          infoWindow.setContent(name);
          infoWindow.open({
            anchor: marker
          });
        }
      })(parking.name, parkingMarker));
    }, i * 5);
  });
}
