/**
 * rscgrid main component
 * React provided at window via reactR
 */

import { cloneDeep } from 'lodash';
import PropTypes from 'prop-types';
import { contentImgSrc } from '@/utils';
import GridPagination from './GridPagination';
import './gridView.scss';

dayjs.extend(dayjs_plugin_localizedFormat);

const gridClass = {
  base: 'rscgrid__grid',
  emptyResults: 'rscgrid__grid rscgrid__grid--empty',
};

// const imgClass = {
//   base: 'rscgrid-item__img',
//   noAccess: 'rscgrid-item__img rscgrid-item__img--no-access',
// };

class GridView extends React.Component {
  constructor(props) {
    super(props);

    this.reset = this.reset.bind(this);
    this.filter = this.filter.bind(this);
    this.paginate = this.paginate.bind(this);
    this.onFilterChange = this.onFilterChange.bind(this);

    const crosstalkHandle = new crosstalk.FilterHandle();
    crosstalkHandle.setGroup(props.crosstalkGroup)
    crosstalkHandle.on('change', this.onFilterChange);

    const originalData = HTMLWidgets.dataframeToD3(props.data);
    this.state = {
      originalData,
      currentPage: 1,
      itemsPerPage: 12,
      data: cloneDeep(originalData),
    };
  }

  onFilterChange(ev) {
    const tableRows = ev.value;
    if (!tableRows) {
      // null, no active filters
      this.reset();
    } else {
      // filter results
      this.filter(tableRows);
    }
  }

  filter(tableRows) {
    const data = tableRows.map(rowIndex => {
      // data rows start at 1, thus -1 to match index 
      return { ...this.state.originalData[rowIndex - 1] };
    });
    this.setState({
      data,
      currentPage: 1,
    });
  }
  
  reset() {
    this.setState({
      data: cloneDeep(this.state.originalData),
      currentPage: 1,
    });
  }

  // <span role="img" aria-label="locked content">🔒</span>
  pageItems() {
    const { currentPage, itemsPerPage } = this.state;
    const startIndex = (currentPage - 1) * itemsPerPage;
    const items = this.state.data.slice(startIndex, startIndex + itemsPerPage);
    return items.map((item, index) => {
      const imgUrl = contentImgSrc(item.url, item.guid);
      return (
        <a
        className="rscgrid-item"
        target="_blank"
        href={item.url}
        rel="noreferrer"
        key={index}
        >
          <figure
            className="rscgrid-item__img rscgrid-item__img--no-access"
            style={{backgroundImage: `url("${imgUrl}")`}}
          />
          <h2 className="rscgrid-item__title">
            {item.title || item.name}
          </h2>
          <div className="rscgrid-item__meta">
            <span>{item.owner_username}</span> • <time>{dayjs(item.updated_time).format('ll')}</time>
          </div>
        </a>
      );
    });
  }

  paginate(page) {
    this.setState({ currentPage: page });
  }

  render() {
    const pageItems = this.pageItems();
    return (
      <div className="rscgrid">
        <div className={this.state.data.length ? gridClass.base : gridClass.emptyResults}>
          {
            pageItems.length
              ? pageItems
              : "No content found"
          }
        </div>
        <GridPagination
          total={this.state.data.length}
          perPage={this.state.itemsPerPage}
          currentPage={this.state.currentPage}
          onChange={this.paginate}
        />
      </div>
    );
  }
}

GridView.propTypes = {
  data: PropTypes.object,
  crosstalkGroup: PropTypes.string,
}

export default GridView;
 