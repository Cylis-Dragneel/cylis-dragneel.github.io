# Cylis Portfolio

Personal portfolio website with blog, built with Astro, Tailwind CSS v4, and MDX.

**Live site:** [cylis.is-a.dev](https://cylis.is-a.dev)

## Tech Stack

- **Framework:** [Astro](https://astro.build/) 5.x
- **Styling:** [Tailwind CSS](https://tailwindcss.com/) v4
- **Content:** MDX for blog posts
- **Runtime:** [Bun](https://bun.sh/)
- **Deployment:** GitHub Pages

## Getting Started

### Prerequisites

This project uses [Nix Flakes](https://nixos.wiki/wiki/Flakes) for development dependencies. If you have Nix installed with flakes enabled:

```bash
# Enter the development shell
nix develop

# Or with direnv
direnv allow
```

Alternatively, ensure you have:
- [Bun](https://bun.sh/) installed
- [Git LFS](https://git-lfs.github.com/) for images

### Development

```bash
# Install dependencies
bun install

# Start dev server (http://localhost:4321)
bun run dev

# Build for production
bun run build

# Preview production build
bun run preview

# Type check
bun run check
```

## Project Structure

```
├── src/
│   ├── components/        # Astro components
│   │   └── blog/          # Blog-specific components
│   ├── content/
│   │   └── blog/          # MDX blog posts
│   ├── layouts/           # Page layouts
│   ├── pages/             # Routes
│   └── styles/            # Global CSS
├── public/
│   └── blog/img/          # Blog images (Git LFS)
└── astro.config.mjs
```

## Writing Blog Posts

### Creating a New Post

1. Create a new `.mdx` file in `src/content/blog/`:

```mdx
---
title: "Your Post Title"
date: 2025-02-10
author: "Cylis"
summary: "A brief description for the blog listing"
tags: ["Tag1", "Tag2"]
---

Your content here...
```

### Frontmatter Fields

| Field     | Type     | Required | Default   | Description                    |
|-----------|----------|----------|-----------|--------------------------------|
| `title`   | string   | Yes      | -         | Post title                     |
| `date`    | date     | Yes      | -         | Publication date (YYYY-MM-DD)  |
| `author`  | string   | No       | "Cylis"   | Author name                    |
| `summary` | string   | Yes      | -         | Brief description for listings |
| `tags`    | string[] | Yes      | -         | Array of tags                  |
| `draft`   | boolean  | No       | false     | Hide from listings if true     |

### Adding Images

1. Place images in `public/blog/img/`
2. Reference in your post:

**Standard Markdown:**
```markdown
![Alt text](/blog/img/your-image.png)
```

**Image Component** (for more control):
```mdx
import Image from "../../components/blog/Image.astro";

<Image 
  src="your-image.png" 
  alt="Description" 
  caption="Optional caption"
  size="medium"      // small | medium | large | full
  position="center"  // left | center | right
/>
```

### Using Components

Import and use custom components in your MDX:

```mdx
import Spoiler from "../../components/blog/Spoiler.astro";
import Callout from "../../components/blog/Callout.astro";
import Image from "../../components/blog/Image.astro";
import ImageGrid from "../../components/blog/ImageGrid.astro";

// Spoiler - collapsible content
<Spoiler title="Click to reveal">
  Hidden content here
</Spoiler>

// Callout - info boxes
<Callout type="tip" title="Pro Tip">
  Helpful information
</Callout>

// Types: info (default), warning, error, tip
```

### Example Post

```mdx
---
title: "My Anime Review"
date: 2025-02-10
author: "Cylis"
summary: "A review of an amazing anime series"
tags: ["Anime", "Review"]
---

import Spoiler from "../../components/blog/Spoiler.astro";

## Overview

This anime was incredible! Here's why...

![Scene from episode 1](/blog/img/anime-screenshot.png)

## Plot Discussion

<Spoiler title="Major Spoilers">
  The twist at the end was unexpected!
</Spoiler>

**Score: 9/10**
```

## Git LFS

Images are tracked with Git LFS. This is already configured for:
- `.png`, `.jpg`, `.jpeg`, `.gif`, `.webp`

```bash
# Verify LFS is working
git lfs ls-files

# Pull LFS files if missing
git lfs pull
```

## Deployment

The site automatically deploys to GitHub Pages when pushing to `main`. The workflow:

1. Checks out code with LFS
2. Sets up Bun
3. Installs dependencies and builds
4. Deploys to GitHub Pages

## License

All rights reserved. Blog content and design are personal work.
