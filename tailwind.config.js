const colors = require('tailwindcss/colors') 
delete colors['lightBlue'];
delete colors['warmGray'];
delete colors['trueGray'];
delete colors['coolGray'];
delete colors['blueGray'];

/** @type {import('tailwindcss').Config} */
module.exports = { 
    content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
	'./node_modules/flowbite/**/*.js',	
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
			screens: {
		  	  	'sm': '640px',
		        // => @media (min-width: 640px) { ... }

		        'md': '768px',
		        // => @media (min-width: 768px) { ... }

		        'lg': '1024px',
		        // => @media (min-width: 1024px) { ... }

		        'xl': '1280px',
		        // => @media (min-width: 1280px) { ... }
			        'widescreen': { 'raw': '(min-aspect-ratio: 3/2)' },
			        'tallscreen': { 'raw': '(min-aspect-ratio: 13/20)' },
			      },
			     }, 
    }, 
    plugins: [
      require('@tailwindcss/forms'),
	  require('flowbite/plugin')
    ], 
}
