import clsx from 'clsx';
import Heading from '@theme/Heading';
import styles from './styles.module.css';

type FeatureItem = {
  title: string;
  description: JSX.Element;
};

const FeatureList: FeatureItem[] = [
  {
    title: 'GPU-Accelerated Spark',
    description: (
      <>
        Leverage NVIDIA's RAPIDS to accelerate Spark-based ETL, machine learning, and AI workloads using GPUs, dramatically reducing processing times.
      </>
    ),
  },
  {
    title: 'Unmatched Data and ML Performance',
    description: (
      <>
        Achieve up to 10x faster performance in data and machine learning tasks, optimizing operations like sorting, joining, and aggregation.
      </>
    ),
  },
  {
    title: 'Scalability with Kubernetes',
    description: (
      <>
        Run and scale Spark RAPIDS jobs efficiently with Kubernetes, ensuring dynamic resource allocation and high availability for GPU-accelerated workflows.
      </>
    ),
  },
];

function Feature({title, description}: FeatureItem) {
  return (
    <div className={clsx('col col--4', styles.centerContent)}>
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
      <div className={clsx('container', styles.centerWrapper)}>
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
