import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 3001,
    proxy: {
      '/api': {
        target: 'https://api.prikriti.co.in/media/miracle',
        changeOrigin: true,
        secure: false,
      }
    }
  }
})