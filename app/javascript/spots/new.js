const clearSessionStorage = () => {
  const placeName = sessionStorage.getItem('placeName');
  if (placeName) {
    sessionStorage.removeItem('placeName')
  }
}

window.addEventListener('beforeunload', clearSessionStorage());