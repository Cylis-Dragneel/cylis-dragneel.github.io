// src/assets/js/blog-post.js
import MarkdownIt from "markdown-it";
import markdownItCheckbox from "markdown-it-checkbox";
import markdownItAnchor from "markdown-it-anchor";
import { slugify } from "./utils.js";

document.addEventListener("DOMContentLoaded", async () => {
  // Theme Toggle
  const themeToggle = document.getElementById("theme-toggle");
  const body = document.body;

  // Check for saved theme preference
  const savedTheme = localStorage.getItem("theme");
  if (savedTheme === "light") {
    body.setAttribute("data-theme", "light");
    themeToggle.checked = true;
  }

  // Theme toggle functionality
  themeToggle.addEventListener("change", () => {
    if (themeToggle.checked) {
      body.setAttribute("data-theme", "light");
      localStorage.setItem("theme", "light");
    } else {
      body.setAttribute("data-theme", "dark");
      localStorage.setItem("theme", "dark");
    }
  });

  // Simple access function to check if post exists
  async function checkPostExistence(postId) {
    try {
      const response = await fetch(`blog/${postId}.md`);
      return response.status === 200;
    } catch (error) {
      return false;
    }
  }

  async function loadBlogPost() {
    try {
      const urlParams = new URLSearchParams(window.location.search);
      const postId = urlParams.get("id");

      if (!postId) {
        showError("No blog post specified");
        return;
      }

      // First check - metadata
      const metadataResponse = await fetch("blog/posts.json");
      const metadata = await metadataResponse.json();
      const post = metadata.posts.find((p) => p.id === postId);

      if (!post) {
        throw new Error("Post not found in metadata");
      }

      // Update post title and metadata
      document.getElementById("blog-title").textContent = post.title;
      document.title = `${post.title} - Cylis Blog`;

      const formattedDate = new Date(post.date).toLocaleDateString("en-US", {
        year: "numeric",
        month: "long",
        day: "numeric",
      });

      document.getElementById("blog-date").textContent = formattedDate;
      document.getElementById("blog-author").textContent = `by ${post.author}`;

      // Check if post should redirect
      if (post.available === false) {
        window.location.href = `/coming-soon.html?title=${encodeURIComponent(post.title)}&id=${encodeURIComponent(post.id)}`;
        return;
      }

      // Check if markdown exists
      const markdownExists = await checkPostExistence(postId);

      if (!markdownExists) {
        window.location.href = `/coming-soon.html?title=${encodeURIComponent(post.title)}&id=${encodeURIComponent(post.id)}`;
        return;
      }

      // Load and render markdown
      try {
        const markdownPath = `blog/${postId}.md`;
        const response = await fetch(markdownPath);
        const text = await response.text();

        // Initialize markdown-it
        const md = new MarkdownIt({
          highlight: function (code, lang) {
            const language = hljs.getLanguage(lang) ? lang : "plaintext";
            return hljs.highlight(code, { language }).value;
          },
          breaks: true,
          html: true, // Enable HTML tags in source
        })
          .use(markdownItCheckbox) // Register the checkbox plugin
          .use(markdownItAnchor, {
            slugify: slugify,
            permalink: markdownItAnchor.permalink.headerLink(),
          });

        // Adjust image path
        md.renderer.rules.image = (tokens, idx, options, env, self) => {
          const token = tokens[idx];
          const src = token.attrGet("src");
          const alt = token.content;
          if (src.startsWith("https")) {
            return `<img src="${src}" alt="${alt}" />`;
          } else {
            const imagePath = `blog/${src}`;
            return `<img src="${imagePath}" alt="${alt}" />`;
          }
        };

        // Render the content
        document.getElementById("blog-content").innerHTML = md.render(text);

        // Process code blocks
        document.querySelectorAll("pre code").forEach((block) => {
          hljs.highlightElement(block);

          const languageClass = [...block.classList].find((cls) =>
            cls.startsWith("language-"),
          );
          if (languageClass) {
            const language = languageClass.replace("language-", "");
            block.parentElement.setAttribute("data-language", language);
          }
        });
      } catch (renderError) {
        showError("Error rendering markdown: " + renderError.message);
      }
    } catch (error) {
      showError(error.message);
    }
  }

  // Start the loading process
  await loadBlogPost();

  function showError(message) {
    document.getElementById("blog-content").innerHTML = `
      <div class="error-message">
        <p>Failed to load blog post: ${message}</p>
        <a href="blog.html" class="btn-back">← Back to all posts</a>
      </div>
    `;
  }
});
