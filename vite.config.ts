import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

export default defineConfig({
  resolve: {
    alias: {
      '~bootstrap': 'node_modules/bootstrap'
    }
  },
  plugins: [
    RubyPlugin(),
  ],
})
