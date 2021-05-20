/**
 * The ContentImage component is meant to be used internally by rsc* components.
 * <ContentImage /> handles fetching the image for content and display permissions
 * related messaging if the user doesn't have access to the content.
 */

import PropTypes from 'prop-types';
import { appModeImg } from '@/appMode';
import './contentImage.scss';

const imageClass = {
  base: 'rscimage',
  noAccess: 'rscimage rscimage--no-access',
}

class ContentImage extends React.Component {
  constructor(props) {
    super(props);
    const defaultImage = appModeImg(props.contentType, props.contentCategory);

    this.state = {
      loaded: false,
      imgUrl: defaultImage,
      imgClass: imageClass.base,
    };
    this.resolveImage = this.resolveImage.bind(this);
    this.resolveImage();
  }

  resolveImage() {
    fetch(this.props.imageUrl)
      .then(res => {
        switch (res.status) {
          case 200:
            return res.blob();
          case 403:
            this.setState({ imgClass: imageClass.noAccess });
            return;
        }
      })
      .then(blob => {
        if (blob) {
          this.setState({ imgUrl: URL.createObjectURL(blob) });
        }
        this.setState({ loaded: true });
      })
      .catch(() => {
        // when fetch errors (NetworkError), it is because the resource
        // was requested outside the Connect instance domain (e.g IDE Knitting).
        // Use default image and no need to show request access badge
        this.setState({ loaded: true });
      });
  }

  render() {
    return (
      <a
        className={this.state.imgClass}
        target="_blank"
        href={this.props.contentUrl}
        rel="noreferrer"
      >
        <figure
          className="rscimage__img"
          style={{ backgroundImage: `url("${this.state.imgUrl}")` }}
        ></figure>
        <span className='rscimage__request-access'>
          REQUEST ACCESS
        </span>      
      </a>
    );
  }
}
 
ContentImage.propTypes = {
  imageUrl: PropTypes.string,
  contentUrl: PropTypes.string,
  contentType: PropTypes.string,
  contentCategory: PropTypes.string,
};

export default ContentImage;
