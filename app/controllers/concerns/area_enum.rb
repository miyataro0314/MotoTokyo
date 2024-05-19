module AreaEnum
  extend ActiveSupport::Concern

  included do
    enum area: {
      chiyoda: 0, chuo: 5, minato: 10, shinjuku: 15, bunkyo: 20, taito: 25,
      sumida: 30, koto: 35, shinagawa: 40, meguro: 45, ota: 50, setagaya: 55,
      shibuya: 60, nakano: 65, suginami: 70, toshima: 75, kita: 80, arakawa: 85,
      itabashi: 90, nerima: 95, adachi: 100, katsushika: 105, edogawa: 110, hachioji: 115,
      tachikawa: 120, musashino: 125, mitaka: 130, ome: 135, fuchu: 140, akishima: 145,
      chofu: 150, machida: 155, koganei: 160, kodaira: 165, hino: 170, higashimurayama: 175,
      kokubunji: 180, kunitachi: 185, fussa: 190, komae: 195, higashiyamato: 200, kiyose: 205,
      higashikurume: 210, musashimurayama: 215, tama: 220, inagi: 225, hamura: 230, akiruno: 235,
      nishitokyo: 240, mizuho: 245, hinode: 250, hinohara: 255, okutama: 260, oshima: 265,
      toshima_vil: 270, niijima: 275, kozushima: 280, miyake: 285, mikurajima: 290, hachijo: 295,
      aogashima: 300, ogasawara: 305
    }
  end
end
