import PropTypes from 'prop-types';
import FilterField from './FilterField';
import { FilterType } from './filterType';
import { FilterContext } from './stateUtils';
import './filterFieldsPane.scss';

function FilterFieldsPane({ isActive }) {
  const context = React.useContext(FilterContext);

  let paneClass = 'rscfilter-pane';

  if (isActive) {
    paneClass += ' rscfilter-pane--active';
  }

  return (
    <div className={paneClass}>
      <FilterField
        label="Owner"
        placeholder="Filter people"
        type={FilterType.owner}
      />
      <FilterField
        label="Type"
        placeholder="Select content types"
        type={FilterType.type}
      />
      <FilterField
        label="Tags"
        placeholder="Filter tags"
        type={FilterType.tag}
      />
      <div className="rscfilter-pane__actions">
        <button
          className="rscfilter-pane__actions-reset"
          onClick={() => context.resetFilters()}
        >
          Reset
        </button>
      </div>
    </div>
  );
}

FilterFieldsPane.propTypes = {
  isActive: PropTypes.bool,
}

export default FilterFieldsPane;
