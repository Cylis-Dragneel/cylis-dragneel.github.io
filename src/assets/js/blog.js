document.addEventListener('DOMContentLoaded', async () => {
  console.log('Blog listing script loaded');
  
  // Theme Toggle
  const themeToggle = document.getElementById('theme-toggle');
  const body = document.body;
  
  // Check for saved theme preference
  const savedTheme = localStorage.getItem('theme');
  if (savedTheme === 'light') {
    body.setAttribute('data-theme', 'light');
    themeToggle.checked = true;
  }

  // Theme toggle functionality
  themeToggle.addEventListener('change', () => {
    if (themeToggle.checked) {
      body.setAttribute('data-theme', 'light');
      localStorage.setItem('theme', 'light');
    } else {
      body.setAttribute('data-theme', 'dark');
      localStorage.setItem('theme', 'dark');
    }
  });

  const blogListContainer = document.getElementById('blog-list');
  if (!blogListContainer) return;
  
  try {
    // Show loading state
    blogListContainer.innerHTML = '<div class="loading">Loading blog posts...</div>';
    
    // Fetch blog posts metadata with a cache breaker
    const timestamp = new Date().getTime();
    const response = await fetch(`blog/posts.json?v=${timestamp}`);
    
    if (!response.ok) {
      throw new Error(`Failed to load blog posts (status: ${response.status})`);
    }
    
    const data = await response.json();
    
    // Clear loading state
    blogListContainer.innerHTML = '';
    
    // No posts yet?
    if (data.posts.length === 0) {
      blogListContainer.innerHTML = '<div class="info-message">No blog posts yet. Check back soon!</div>';
      return;
    }
    
    // Sort posts by date (newest first)
    data.posts.sort((a, b) => new Date(b.date) - new Date(a.date));
    
    // Create blog post cards efficiently using document fragment
    const fragment = document.createDocumentFragment();
    
    data.posts.forEach(post => {
      const formattedDate = new Date(post.date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
      
      const postElement = document.createElement('div');
      postElement.classList.add('blog-card');
      
      // Tag HTML generation
      const tagsHTML = post.tags.map(tag => 
        `<span class="blog-tag">${tag}</span>`).join('');
      
      // Availability badge
      const availabilityBadge = post.available === false 
        ? '<span class="coming-soon-badge">Coming Soon</span>' 
        : '';
      
      // Link to proper page
      const postLink = post.available === false 
        ? `coming-soon.html?title=${encodeURIComponent(post.title)}&id=${encodeURIComponent(post.id)}`
        : `blog-post.html?id=${post.id}`;
      
      // Set inner HTML
      postElement.innerHTML = `
        <h3 class="blog-title">
          <a href="${postLink}">${post.title}</a>
          ${availabilityBadge}
        </h3>
        <div class="blog-meta">
          <span class="blog-date">${formattedDate}</span>
          <span class="blog-author">by ${post.author}</span>
        </div>
        <p class="blog-summary">${post.summary}</p>
        <div class="blog-tags">${tagsHTML}</div>
        <a href="${postLink}" class="blog-read-more">
          ${post.available === false ? 'View details →' : 'Read more →'}
        </a>
      `;
      
      fragment.appendChild(postElement);
    });
    
    blogListContainer.appendChild(fragment);
    
  } catch (error) {
    console.error('Error loading blog posts:', error);
    blogListContainer.innerHTML = `
      <div class="error-message">
        <p>Failed to load blog posts. Please try again later.</p>
        <p>Error: ${error.message}</p>
      </div>
    `;
  }
});