// 画像とsvg部分
const swiperMain = new Swiper(".swiper-main", {
  centeredSlides: true,
  slidesPerView: calculateSpaceBetween(),
  spaceBetween: calculateSpaceBetween(),
});

// 下の説明部分
const swiperParagraph = new Swiper('.swiper-paragraph', {
  centeredSlides: true,
  slidesPerView: calculateSpaceBetween(),
  spaceBetween: calculateSpaceBetween(),
});

// 2つのswiperを同期
swiperMain.controller.control = swiperParagraph;
swiperParagraph.controller.control = swiperMain;


// 徐々に間隔が広くなるよう設定
function calculateSpaceBetween() {
  let screenWidth = window.innerWidth;
  return (screenWidth * 0.05) ** 1.2;
}

//　徐々にページ数が大きくなるよう設定（2~3程度）
function calculateSlidesPerView() {
  let screenWidth = window.innerWidth;
  return (screenWidth + 2400) / 1750
}

// 計算結果の割当て
function updateSpaceBetween() {
  swiperMain.params.spaceBetween = calculateSpaceBetween();
  swiperParagraph.params.spaceBetween = calculateSpaceBetween();
  swiperMain.update();
  swiperParagraph.update();
}
function updateSlidesPerView() {
  swiperMain.params.slidesPerView = calculateSlidesPerView();
  swiperMain.update();
  swiperParagraph.params.slidesPerView = calculateSlidesPerView();
  swiperParagraph.update();
}

// 幅に合わせて高さとロゴの大きさも調整
function adjustSwiperHeights() {
  const slide = document.querySelector('.swiper-main .swiper-slide');
  const slides = document.querySelectorAll('.swiper-main .swiper-slide');
  const wrapper = document.querySelector('.swiper-main .swiper-wrapper');
  const logo = document.querySelector('.logo');
  wrapper.style.height = (slide.offsetWidth * 1.3) + 'px'
  slides.forEach((slide) => {
    slide.style.height = (slide.offsetWidth * 1.3) + 'px';
  });
  logo.style.width = (slide.offsetWidth * 0.8) + 'px'
  logo.style.height = (slide.offsetWidth * 0.3) + 'px'
}

// 画面変更時に大きさ調整
window.addEventListener('resize', function() {
  updateSpaceBetween();
  updateSlidesPerView();
  adjustSwiperHeights();
});

// 初期表示時に適切な大きさ計算
updateSpaceBetween();
updateSlidesPerView();
adjustSwiperHeights();

// transition初期動作回避のためロード後に追加
window.addEventListener('turbo:load', function() {
  const mainSlides = document.querySelectorAll('.swiper-main .swiper-slide');
  const paragraphSlides = document.querySelectorAll('.swiper-paragraph .swiper-slide');
  mainSlides.forEach((slide) => {
    slide.style.transition = 'transform 0.3s, opactity 0.3s';
  });
  paragraphSlides.forEach((slide) => {
    slide.style.transition = 'transform 0.5s cubic-bezier(0.7,0.25,0.6,1), opactity 0.5s cubic-bezier(0.7,0.25,0.6,1)';
  });
})