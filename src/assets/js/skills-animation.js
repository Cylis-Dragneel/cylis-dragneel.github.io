document.addEventListener('DOMContentLoaded', () => {
  console.log('Skills animation script loaded');
  
  // Function to start animation
  function animateSkills() {
    const skillItems = document.querySelectorAll('.skill-item');
    console.log(`Found ${skillItems.length} skill items to animate`);
    
    skillItems.forEach(skillItem => {
      const progressBar = skillItem.querySelector('.skill-progress');
      if (!progressBar) {
        console.error('No .skill-progress element found in', skillItem);
        return;
      }
      
      const width = progressBar.style.width;
      console.log(`Setting up animation for skill with width ${width}`);
      
      // Store the original width as a data attribute
      progressBar.setAttribute('data-width', width);
      
      // Set scale transform based on the width
      const scaleValue = parseFloat(width) / 100;
      progressBar.style.transform = `scaleX(0)`;
    });
    
    // Use IntersectionObserver to trigger animations when scrolled into view
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const progressBar = entry.target.querySelector('.skill-progress');
          if (progressBar) {
            // Add animate class with a slight delay
            setTimeout(() => {
              progressBar.classList.add('animate');
              const width = progressBar.getAttribute('data-width');
              progressBar.style.transform = `scaleX(${parseFloat(width) / 100})`;
              console.log('Animated skill bar to width:', width);
            }, 100);
          }
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.2 });
    
    // Observe all skill items
    skillItems.forEach(item => observer.observe(item));
  }
  
  // Run animation setup after a short delay
  setTimeout(animateSkills, 200);
});