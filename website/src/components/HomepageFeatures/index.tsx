import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  Svg: React.ComponentType<React.ComponentProps<'svg'>>;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'Enable GPU-accelerated data science workflows',
    Svg: require('@site/static/img/undraw_docusaurus_mountain.svg').default,
    description: (
      <>
        RAPIDS, a project developed by NVIDIA, comprises a suite of open-source libraries that are hinged upon CUDA, thereby enabling GPU-accelerated data science workflows
      </>
    ),
  },
  {
    title: 'Experience unparralel performance boost in your data processing workflows',
    Svg: require('@site/static/img/undraw_docusaurus_tree.svg').default,
    description: (
      <>
        Experience a performance boost in data preparation tasks, allowing you to transition quickly to the subsequent stages of your pipeline..
      </>
    ),
  },
  {
    title: 'Powered by NVIDIA GPU Architecture',
    Svg: require('@site/static/img/undraw_docusaurus_react.svg').default,
    description: (
      <>
        A transformative parallel computing platform designed for enhancing computational processes on NVIDIA's GPU architecture.
      </>
    ),
  },
];

function Feature({title, Svg, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} role="img" />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures(): JSX.Element {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
