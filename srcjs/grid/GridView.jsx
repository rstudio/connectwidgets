/**
 * rscgrid main component
 * React provided at window via reactR
 */

import { cloneDeep } from 'lodash';
import PropTypes from 'prop-types';
import './grid.scss';

class GridView extends React.Component {
  constructor(props) {
    super(props);
    const crosstalkHandle = new crosstalk.FilterHandle();
    crosstalkHandle.setGroup(props.crosstalkGroup)
    crosstalkHandle.on('change', ev => {
      const tableRows = ev.value;
      if (!tableRows || !tableRows.length) {
        this.reset();
      } else {
        this.filter(tableRows);
      }
    });

    const originalData = HTMLWidgets.dataframeToD3(props.data);
    this.state = {
      originalData,
      data: cloneDeep(originalData),
    };

    this.reset = this.reset.bind(this);
    this.filter = this.filter.bind(this);
  }

  filter(tableRows) {
    const data = tableRows.map(rowIndex => {
      // data rows start at 1, thus -1 to match index 
      return { ...this.state.originalData[rowIndex - 1] };
    });
    this.setState({ data });
  }
  
  reset() {
    this.setState({
      data: cloneDeep(this.state.originalData),
    });
  }

  render() {
    return (
      <div className="rscgrid">
        {
          this.state.data.map((item, index) => {
            return (
              <a
                className="rscgrid-item"
                target="_blank"
                href={item.url}
                key={index}
              >
                <figure
                  className="rscgrid-item__img"
                  style={{backgroundImage: `url("${this.props.images[index]}")`}}
                />
                <h2 className="rscgrid-item__title">{item.title}</h2>
                <div className="rscgrid-item__meta">
                  <span>{item.owner_username}</span> • <time>{new Date(item.updated_time).toDateString()}</time>
                </div>
              </a>
            );
          })
        }
      </div>
    );
  }
}

GridView.propTypes = {
  data: PropTypes.object,
  images: PropTypes.array,
  crosstalkGroup: PropTypes.string,
}

export default GridView;
 