module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],

  theme: {
    extend: {
      spacing: {
        '7': '28px',
        '42': '168px',
        '88': '352px',
        '112': '448px',
        '120': '480px',
        '128': '512px'
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
        'error': '#fbbf24',
        'base-100': '#f5f2e9',
        'base-300': '#fbfbfb'
        }
      }
    ],
    prefix: 'daisy-'
  }
}
