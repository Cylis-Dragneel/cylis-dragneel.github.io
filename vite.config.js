import { defineConfig } from "vite";
import { resolve } from 'path';

export default defineConfig({
  root: "src",
  build: {
    outDir: "../dist",
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'src/index.html'),
        blog: resolve(__dirname, 'src/blog.html'),
      },
    },
    // Ensure assets are correctly handled
    assetsDir: "assets",
    // Generate manifest for better path handling
    manifest: true,
  },
  // Copy any static assets that shouldn't be processed
  publicDir: "public",
  server: { 
    open: true,
    // Ensure paths are correctly resolved in development
    fs: {
      allow: ['..']
    }
  },
  // Use base URL for GitHub Pages if needed
  // base: "/portfolio/" // Uncomment if deploying to username.github.io/portfolio/
  // If deploying to custom domain, use: base: "/"
});
