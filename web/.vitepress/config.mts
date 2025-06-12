import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "FunBox",
  description: "A treasure trove of interesting and practical little tools.",
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: '首页', link: '/' },
      { text: '开始', link: '/guide/start' }
    ],
    footer: {
        message: '感谢GitHub Pages提供网站搭建服务',
        copyright: 'Copyright © 2025-现在 酷安@我不是尘桑。'
    },
    editLink: {
        pattern: 'https://github.com/mcxiaochenn/Action_OKI_KernelSU_SUSFS/edit/main/docs/:path',
        text: '在 GitHub 中编辑本页'
    },
    lastUpdated: {
      text: '最后更新于'
    },



    sidebar: [
      {
        text: 'Guide',
        items: [
          { text: '开始', link: '/guide/start' },
          { text: 'Arch-Purge 🧹', link: '/guide/Arch-Linux/Arch-Purge' }
        ]
      }
    ],



    socialLinks: [
      { icon: 'github', link: 'https://github.com/mcxiaochenn/FunBox' }
    ]
  }
})
