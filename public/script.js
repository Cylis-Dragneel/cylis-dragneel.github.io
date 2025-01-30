// script.js
document.addEventListener("DOMContentLoaded", () => {
  // Theme Toggle
  const themeToggle = document.getElementById("theme-toggle");
  const body = document.body;

  themeToggle.addEventListener("change", () => {
    if (themeToggle.checked) {
      body.setAttribute("data-theme", "light");
    } else {
      body.setAttribute("data-theme", "dark");
    }
  });

  // Typing Animation
  const text = "Building, Automating, Deploying.";
  const typingText = document.querySelector(".typing-text");
  let i = 0;

  function typeWriter() {
    if (i < text.length) {
      typingText.textContent += text.charAt(i);
      i++;
      setTimeout(typeWriter, 100);
    }
  }

  typeWriter();

  // Skill Bars Animation
  const skillBars = document.querySelectorAll(".skill-progress");

  const observerOptions = {
    threshold: 0.5,
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.style.width = entry.target.parentElement.dataset.progress;
      }
    });
  }, observerOptions);

  skillBars.forEach((bar) => observer.observe(bar));

  // Smooth Scrolling
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();
      document.querySelector(this.getAttribute("href")).scrollIntoView({
        behavior: "smooth",
      });
    });
  });
});
