import { range } from 'lodash';
import PropTypes from 'prop-types';
import './gridPagination.scss';

const btnClass = {
  base: 'rscgrid-pagination__btn',
  current: 'rscgrid-pagination__btn rscgrid-pagination__btn--current',
};

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
          key={index}
        >
          <button
            className={currentPage === pageNum ? btnClass.current : btnClass.base}
            onClick={() => gotoPage(pageNum)}
          >{pageNum}</button>
        </li>
      );
    });
  }

  function gotoPage(page) {
    if (page !== currentPage) {
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
      <ul className="rscgrid-pagination__list">
        <li>
          <button
            className={btnClass.base}
            disabled={disablePrevious()}
            onClick={() => gotoPage(currentPage - 1)}
          >❮</button>
        </li>
        {pageButtons()}
        <li>
          <button
            className={btnClass.base}
            disabled={disableNext()}
            onClick={() => gotoPage(currentPage + 1)}
          >❯</button>
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
