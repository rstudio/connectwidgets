/**
 * rsccard main component
 * React provided at window via reactR
 */

import PropTypes from 'prop-types';
import ContentImage from '@/image';
import { contentImgSrc } from '@/utils';
import './card.scss';

function Card({ data }) {
  const contentObj = HTMLWidgets.dataframeToD3(data)[0];
  const imgUrl = contentImgSrc(contentObj.url, contentObj.guid);

  return (
    <div className="rsccard">
      <div
        className='rsccard__img'
      >
        <ContentImage
          imageUrl={imgUrl}
          contentUrl={contentObj.url}
          contentType={contentObj.app_mode}
        />
      </div>
      <div className="rsccard__meta">
        <span>{contentObj.owner_username}</span> • <time>{new Date(contentObj.updated_time).toDateString()}</time>
        <h2 className="rsccard__meta-title">
          {contentObj.title || contentObj.name}
        </h2>
        <p className="rsccard__meta-description">
          {contentObj.description}
        </p>
        <a
          className="rsccard__meta-link"
          href={contentObj.url}
          target="_blank"
          rel="noreferrer"
        >Open Content</a>
      </div>
    </div>
  );
}

Card.propTypes = {
  data: PropTypes.object,
}

export default Card;
