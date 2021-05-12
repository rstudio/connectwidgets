import { range } from 'lodash';
import PropTypes from 'prop-types';
import './gridPagination.scss';

const btnClass = {
  base: 'rscgrid-pagination__btn',
  current: 'rscgrid-pagination__btn rscgrid-pagination__btn--current',
};

function GridPagination({ total, perPage, currentPage, onChange }) {
  const totalPages = Math.ceil(total / perPage);

  function pageButtons() {
    return range(totalPages).map(index => {
      const pageNum = index + 1;
      return (
        <li
          key={index}
        >
          <button
            className={currentPage === pageNum ? btnClass.current : btnClass.base}
            onClick={() => gotoPage(pageNum)}
          >{pageNum}</button>
        </li>
      )
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
