module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],

  theme: {
    extend: {
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
        'primary': '#e36255',
        'primary-content': '#f5f2e9', 
        'secondary': '#a2c5c9',
        'secondary-content': '#292d32',
        'accent': '#a78bfa',
        'neutral': '#292d32',
        'error': 'ef4444',
        'base-100': '#f5f2e9'
        }
      }
    ],
    prefix: 'daisy-'
  }
}
