module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],

  theme: {
    extend: {
      colors: {
        'base': '#4d4d4d', // 基本のフォントカラー（黒系）text-base
        'reverse': '#f5f2e9', // 反転フォントカラー（白色） text-reverse
      },
      height: {
        '112': '28rem',  // 448px h-112
        '120': '30rem',  // 480px h-120
        '128': '32rem'   // 512px h-128
      },
      width: {
        '112': '28rem',  // 448px w-112
        '120': '30rem',  // 480px w-120
        '128': '32rem'   // 512px w-128
      }
    },
  },

  plugins: [
    require('daisyui')
  ],

  daisyui: {
    themes: [
      {
        moto_tokyo: {
        "primary": "#e36255",
        "primary-content": '#f5f2e9', 
        "secondary": "#a2c5c9",
        "secondary-content": '#292d32',
        "accent": "",
        "neutral": "#292d32",
        "base-100": "#f5f2e9",
        }
      }
    ],
    prefix: 'daisy-'
  }
}
