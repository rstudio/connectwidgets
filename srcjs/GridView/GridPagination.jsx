import { range } from 'lodash';
import PropTypes from 'prop-types';
import './gridPagination.scss';

const btnClass = {
  base: 'rscgrid-pagination__btn page-link',
  current: 'rscgrid-pagination__btn rscgrid-pagination__btn--current page-link',
  disabled: 'rscgrid-pagination__btn rscgrid-pagination__btn--disabled page-link',
};

const bsPageClass = {
  base: 'page-item',
  disabled: 'page-item disabled',
  current: 'page-item active',
}

function GridPagination({ total, perPage, currentPage, onChange }) {
  const sep = '...';
  const totalPages = Math.ceil(total / perPage);

  function genPagingRange() {
    if (totalPages < 7) {
      return range(1, totalPages + 1);
    }
    if (totalPages - currentPage < 3) {
      return [1, sep, ...range(totalPages - 3, totalPages + 1)];
    }
    if (currentPage > 4) {
      return [1, sep, ...range(currentPage - 1, currentPage + 2), sep, totalPages];
    }
    return [...range(1, 6), sep, totalPages];
  }

  function pageButtons() {
    return genPagingRange().map((pageNum, index) => {
      if (pageNum === sep) {
        return (
          <li
            className="rscgrid-pagination__sep"
            key={index}
            role="separator"
          >...</li>
        );
      }
      return (
        <li
          className={currentPage === pageNum ? bsPageClass.current : bsPageClass.base}
          key={index}
        >
          {/* eslint-disable */}
          <a
            className={currentPage === pageNum ? btnClass.current : btnClass.base}
            href="#"
            onClick={(ev) => { ev.preventDefault(); gotoPage(pageNum); }}
          >{pageNum}</a>
          {/* eslint-enable */}
        </li>
      );
    });
  }

  function gotoPage(page) {
    const reachedLimit = page == 0 || page > totalPages;
    if (!reachedLimit && page !== currentPage) {
      onChange(page);
    }
  }

  function disablePrevious() {
    return currentPage === 1;
  }

  function disableNext() {
    return currentPage === totalPages || totalPages === 0;
  }

  return (
    <nav className="rscgrid-pagination">
      <ul className="rscgrid-pagination__list pagination">
        <li
          className={disablePrevious() ? bsPageClass.disabled : bsPageClass.base}
        >
          {/* eslint-disable */}
          <a
            className={disablePrevious() ? btnClass.disabled : btnClass.base}
            href="#"
            onClick={(ev) => { ev.preventDefault(); gotoPage(currentPage - 1); }}
          >❮</a>
          {/* eslint-enable */}
        </li>
        {pageButtons()}
        <li
          className={disableNext() ? bsPageClass.disabled : bsPageClass.base}
        >
          {/* eslint-disable */}
          <a
            className={disableNext() ? btnClass.disabled : btnClass.base}
            href="#"
            onClick={(ev) => { ev.preventDefault(); gotoPage(currentPage + 1); }}
          >❯</a>
          {/* eslint-enable */}
        </li>
      </ul>
    </nav>
  );
}

GridPagination.propTypes = {
  total: PropTypes.number,
  perPage: PropTypes.number,
  currentPage: PropTypes.number,
  onChange: PropTypes.func,
}

export default GridPagination;
