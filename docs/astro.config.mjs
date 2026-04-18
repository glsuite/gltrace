import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://glsuite.github.io',
  base: '/gltrace',
  integrations: [
    starlight({
      title: 'GLTrace',
      description: 'Terminal-first GitLab pipeline log explorer.',
      logo: {
        src: './src/assets/logo.svg',
      },
      customCss: ['./src/styles/custom.css'],
      head: [
        {
          tag: 'script',
          content: `
            document.addEventListener('DOMContentLoaded', () => {
              document.querySelectorAll('.social-icons a[href^="http"]').forEach(a => {
                a.target = '_blank';
                a.rel = 'noopener noreferrer';
              });
            });
          `,
        },
      ],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/glsuite/gltrace' },
      ],
      editLink: {
        baseUrl: 'https://github.com/glsuite/gltrace/edit/main/docs/',
      },
      sidebar: [
        {
          label: 'Start here',
          items: [
            { label: 'Introduction', link: '/' },
            { label: 'Quick Start', slug: 'quickstart' },
          ],
        },
        {
          label: 'Usage',
          items: [
            { label: 'Wizard Mode', slug: 'wizard-mode' },
            { label: 'Args Mode', slug: 'args-mode' },
            { label: 'AI Agents', slug: 'ai-agents' },
          ],
        },
        {
          label: 'Reference',
          items: [
            { label: 'CLI Reference', slug: 'cli-reference' },
            { label: 'Environment Variables', slug: 'environment-variables' },
          ],
        },
        {
          label: 'Contributing',
          items: [
            { label: 'Contributing', slug: 'contributing' },
          ],
        },
      ],
    }),
  ],
});
