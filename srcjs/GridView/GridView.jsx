/**
 * rscgrid main component
 * React provided at window via reactR
 */

import { cloneDeep } from 'lodash';
import PropTypes from 'prop-types';
import ContentImage from '@/ContentImage';
import { contentImgSrc } from '@/utils';
import GridPagination from './GridPagination';
import './gridView.scss';

dayjs.extend(dayjs_plugin_localizedFormat);

const gridClass = {
  base: 'rscgrid__grid',
  emptyResults: 'rscgrid__grid rscgrid__grid--empty',
};

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

  pageItems() {
    const { currentPage, itemsPerPage } = this.state;
    const startIndex = (currentPage - 1) * itemsPerPage;
    const items = this.state.data.slice(startIndex, startIndex + itemsPerPage);
    return items.map(item => {
      const imgUrl = contentImgSrc(item.url, item.guid);
      return (
        <div
        className="rscgrid-item"
        key={item.guid || item.name}
        >
          <ContentImage
            imageUrl={imgUrl}
            contentUrl={item.url}
            contentType={item.app_mode}
            contentCategory={item.content_category}
          />
           <a
              href={item.url}
              target="_blank"
              rel="noreferrer"
          >
            <h2 className="rscgrid-item__title">
              {item.title || item.name}
            </h2>
          </a>
          <div className="rscgrid-item__meta">
            <span>{item.owner_username} • <time>{dayjs(item.updated_time).format('ll')}</time></span>
          </div>
        </div>
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
 