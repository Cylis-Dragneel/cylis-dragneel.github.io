import { defineConfig } from "vite";
import { resolve } from "path";

export default defineConfig({
  root: "src",
  build: {
    outDir: "../dist",
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: resolve(__dirname, "src/index.html"),
        blog: resolve(__dirname, "src/blog.html"),
        blogPost: resolve(__dirname, "src/blog-post.html"),
        comingSoon: resolve(__dirname, "src/coming-soon.html"),
        scripts: resolve(__dirname, "src/script.js"),
        css: resolve(__dirname, "src/styles.css"),
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
      allow: [".."],
    },
  },
});
