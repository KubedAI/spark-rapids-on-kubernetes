import {themes as prismThemes} from 'prism-react-renderer';
import type {Config} from '@spark-rapids-on-kubernetes/types';
import type * as Preset from '@spark-rapids-on-kubernetes/preset-classic';

const config: Config = {
  title: 'Spark RAPIDS on Kubernetes',
  tagline: 'Accelereate your Spark on GPUs with Kubernetes',
  favicon: 'img/favicon.ico',

  // Set the production url of your site here
  url: 'https://KubedAI.github.io',
  // Set the /<baseUrl>/ pathname under which your site is served
  // For GitHub pages deployment, it is often '/<projectName>/'
  baseUrl: '/spark-rapids-on-kubernetes/',

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'KubedAI', // Usually your GitHub org/user name.
  projectName: 'spark-rapids-on-kubernetes', // Usually your repo name.

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  githubHost: 'github.com',

  // Even if you don't use internationalization, you can use this field to set
  // useful metadata like html lang. For example, if your site is Chinese, you
  // may want to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      {
        docs: {
          sidebarPath: './sidebars.ts',
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl:
            'https://github.com/Kube-dAI/spark-rapids-on-kubernetes/tree/main/packages/create-spark-rapids-on-kubernetes/templates/shared/',
        },
        theme: {
          customCss: './src/css/custom.css',
        },
      } satisfies Preset.Options,
    ],
  ],

  themeConfig: {
    // Replace with your project's social card
    image: 'img/spark-rapids-on-kubernetes-social-card.jpg',
    navbar: {
      title: 'KubedAI',
      logo: {
        alt: 'Site Logo',
        src: 'img/kubedai-logo.png',
      },
      items: [
        {
          type: 'docSidebar',
          sidebarId: 'docSidebar',
          position: 'left',
          label: 'Documentation',
        },
        {
          href: 'https://github.com/KubedAI/spark-rapids-on-kubernetes',
          position: 'right',
          className: 'header-github-link',
          'aria-label': 'GitHub repository',
        }
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'Docs',
          items: [
            {
              label: 'Documentation',
              to: '/docs/intro',
            },
          ],
        },
        {
          title: 'Community',
          items: [
            {
              label: 'Stack Overflow',
              href: 'https://stackoverflow.com/questions/tagged/spark-rapids-on-kubernetes',
            },
            {
              label: 'Discord',
              href: 'https://discordapp.com/invite/spark-rapids-on-kubernetes',
            },
            {
              label: 'Twitter',
              href: 'https://twitter.com/spark-rapids-on-kubernetes',
            },
          ],
        },
        {
          title: 'More',
          items: [
            // {
            //   label: 'Blog',
            //   to: '/blog',
            // },
            {
              label: 'GitHub',
              href: 'https://github.com/KubedAI/spark-rapids-on-kubernetes',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} KubedAI`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  } satisfies Preset.ThemeConfig,


};

export default config;
