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
    // core layout/padding from your button helpers
    'bg-blue-900',
    'hover:bg-blue-700',
    'text-white',
    'font-light',
    'text-sm',
    'px-3',
    'py-1.5',
    'rounded',
  
    // outline button
    'border',
    'border-blue-900',
    'text-blue-900',
    'hover:bg-blue-100',
  
    // clear link
    'underline',
    'hover:font-semibold',
    'whitespace-nowrap',
    'text-xs',
  
    // if you use state-based classes in helpers:
    {
      pattern: /bg-(red|green|blue|yellow)-(100|200|300|400|500|600|700|800|900)/,
    }
  ],
  theme: {
    extend: {
      screens: {
        'sm': '640px',
        'md': '768px',
        'lg': '1024px',
        'xl': '1280px',
        'widescreen': { 'raw': '(min-aspect-ratio: 3/2)' },
        'tallscreen': { 'raw': '(min-aspect-ratio: 13/20)' },
      },
    },
  },

  plugins: [
    require('@tailwindcss/forms'),
    require('flowbite/plugin'),
    require('tailwind-scrollbar'), // 🛠️ new scrollbar plugin
  ],
}
