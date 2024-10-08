import type {SidebarsConfig} from '@docusaurus/plugin-content-docs';

/**
 * Creating a sidebar enables you to:
 - create an ordered group of docs
 - render a sidebar for each doc of that group
 - provide next/previous navigation

 The sidebars can be generated from the filesystem, or explicitly defined here.

 Create as many sidebars as you want.
 */
const sidebars: SidebarsConfig = {
  docSidebar: [{type: 'autogenerated', dirName: '.'}],
  // By default, Docusaurus generates a sidebar from the docs folder structure
  // introduction: [{type: 'autogenerated', dirName: 'introduction'}],
  // infrastructure: [{type: 'autogenerated', dirName: 'infrastructure'}],
  // blueprints: [{type: 'autogenerated', dirName: 'blueprints'}]

  // But you can create a sidebar manually
  /*
  tutorialSidebar: [
    'intro',
    'hello',
    {
      type: 'category',
      label: 'Tutorial',
      items: ['tutorial-basics/create-a-document'],
    },
  ],
   */
};

export default sidebars;
