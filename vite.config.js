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
        blogPost: resolve(__dirname, 'src/blog-post.html'),
      },
    },
    // Ensure assets are correctly handled
    assetsDir: "assets",
  },
  // Copy any static assets that shouldn't be processed
  publicDir: "../public",
  server: { 
    open: true,
    fs: {
      allow: ['..']
    }
  },
});
