import { defineConfig } from 'vite'
import ViteRails from 'vite-plugin-rails'

export default defineConfig({
  resolve: {
    alias: {
      '~bootstrap': 'node_modules/bootstrap'
    }
  },
  plugins: [
    ViteRails({
      envVars: { RAILS_ENV: 'development' },
    }),
  ],
})
