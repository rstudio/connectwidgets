/**
 * rsccard main component
 * React provided at window via reactR
 */

import PropTypes from 'prop-types';
import './card.scss';

function Card({ data, image }) {
  return (
    <div className="rsccard">
      <figure
        className="rsccard__img"
        style={{backgroundImage: `url("${image}")`}}
      />
      <div className="rsccard__meta">
        <span>{data.owner_username}</span> • <time>{new Date(data.updated_time).toDateString()}</time>
        <h2 className="rsccard__meta-title">
          {data.title}
        </h2>
        <p className="rsccard__meta-description">
          {data.description}
        </p>
        <a
          className="rsccard__meta-link"
          href={data.url}
          target="_blank"
        >View content</a>
      </div>
    </div>
  );
}

Card.propTypes = {
  data: PropTypes.object,
  image: PropTypes.string,
}

export default Card;
