const colors = require('tailwindcss/colors') 
/** @type {import('tailwindcss').Config} */
module.exports = { 
    content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
    ], 

    safelist: [
        {
            pattern: /bg-(red|green|blue)-(100|200|300|400|500|600|700|800|900)/,
        },
    ],

    theme: { 
        extend: { 
            colors: { 
                transparent: 'transparent', 
                current: 'currentColor', 
                black: colors.black, 
                white: colors.white, 
                emerald: colors.emerald, 
                indigo: colors.indigo, 
                yellow: colors.yellow, 
                stone: colors.warmGray, 
                sky: colors.lightBlue, 
                neutral: colors.trueGray, 
                gray: colors.coolGray, 
                slate: colors.blueGray, 
                lime: colors.lime, 
                rose: colors.rose, 
            }, 
        }, 
    }, 
    plugins: [
      require('@tailwindcss/forms')
    ], 
}
