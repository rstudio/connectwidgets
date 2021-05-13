/**
 * rscfilter main component
 * React provided at window via reactR
 */

import PropTypes from 'prop-types';
import { cloneDeep } from 'lodash';
import { FilterType } from './filterType';
import FilterFieldsPane from './FilterFieldsPane';
import { 
  FilterContext,
  parseDataToFilters,
  shallowFiltersState,
} from './stateUtils';
import './filter.scss';

class Filter extends React.Component {
  constructor(props) {
    super(props);

    const crosstalkHandle = new crosstalk.FilterHandle();
    crosstalkHandle.setGroup(props.crosstalkGroup);

    this.parsedData = parseDataToFilters(props.data);
    this.state = {
      showPane: false,
      crosstalkHandle,
      options: cloneDeep(this.parsedData),
      selections: shallowFiltersState(),
      stateOptionsFor: this.stateOptionsFor.bind(this),
      stateSelectionsFor: this.stateSelectionsFor.bind(this),
      searchFieldOptions: this.searchFieldOptions.bind(this),
      updateSelection: this.updateSelection.bind(this),
      resetFilters: this.resetFilters.bind(this),
    };

    this.togglePane = this.togglePane.bind(this);
    this.setupCloseListeners();
  }

  setupCloseListeners() {
    const toggleIfNeeded = ev => {
      const withEscKey = ev.key && ev.key === 'Escape';
      const outOfPane = !ev.target.className.includes('rscfilter');
      if (
        this.state.showPane &&
        (withEscKey || outOfPane)
      ) {
        this.togglePane();
      }
    };

    document.addEventListener('keyup', toggleIfNeeded);
    document.addEventListener('click', toggleIfNeeded);
  }

  stateOptionsFor(type) {
    return this.state.options[type];
  }

  stateSelectionsFor(type) {
    return this.state.selections[type];
  }

  hasFiltersSelected() {
    const anyActiveSelection = Object.values(FilterType)
                                     .find(type => this.state.selections[type].length);
    return Boolean(anyActiveSelection);
  }

  getFiltersMatchingRows() {
    let matchingRows = [];

    Object.values(FilterType).forEach(filterType => {
      const selections = this.state.selections[filterType];
      const applicableRows = [
        ...new Set(selections.reduce((rows, sel) => [...rows, ...sel.applicableRows], []))
      ];
      if (selections.length) {
        if (!matchingRows.length) {
          matchingRows.push(...applicableRows)
        } else {
          matchingRows = matchingRows.filter(row => applicableRows.includes(row))
        }
      }
    });

    return matchingRows;
  }

  searchFieldOptions(type, prefix) {
    let newOptionsState = cloneDeep(this.parsedData[type]);
    const currentSelections = this.state.selections[type];

    // If search is empty and there are pre-filtered options, reset and mark those selected
    if (!prefix && currentSelections.length) {
      currentSelections.forEach(opt => newOptionsState[opt.index].isSelected = true);
    } else {
    // Else, filter options with prefix and mark those already selected
      const reg = new RegExp(prefix, "i");
      newOptionsState = newOptionsState.filter(opt => reg.test(opt.label)).map(opt => {
        opt.isSelected = Boolean(currentSelections.find(s => s.name === opt.name));
        return opt;
      });
    }
    
    this.setState({
      options: { ...this.state.options, [type]: newOptionsState }
    });
  }

  updateSelection(target) {
    const { name, isSelected, filterType } = target;
    const newOptionsState = cloneDeep(this.state.options[filterType]);
    const newSelectionsState = cloneDeep(this.state.selections[filterType]);

    const targetInState = newOptionsState.find(opt => opt.name === name);
    targetInState.isSelected = isSelected;

    if (isSelected) {
      newSelectionsState.push(target);
    } else {
      const indexOnSelection = newSelectionsState.findIndex(opt => opt.name === name);
      newSelectionsState.splice(indexOnSelection, 1);
    }

    this.setState({
      options: { ...this.state.options, [filterType]: newOptionsState },
      selections: { ...this.state.selections, [filterType]: newSelectionsState },
    }, () => {
      if (!this.hasFiltersSelected()) {
        this.state.crosstalkHandle.clear();
        return;
      }
      const matchingRows = this.getFiltersMatchingRows();
      this.state.crosstalkHandle.set(matchingRows);
    });
  }

  filtersCount() {
    const count = Object.values(this.state.selections).reduce((res, filt) => res + filt.length, 0);
    return count > 0 ? count : "";
  }
  
  resetFilters() {
    this.setState({
      options: cloneDeep(this.parsedData),
      selections: shallowFiltersState(),
    }, () => {
      this.state.crosstalkHandle.clear();
    });
  }

  togglePane() {
    this.setState({ showPane: !this.state.showPane });
  }

  render() {
    return (
      <FilterContext.Provider value={this.state}>
        <div className="rscfilter">
          <button
            className="rscfilter__toggle"
            onClick={this.togglePane}
          >
            Filter
          <span
            className="rscfilter__count"
          >
            {this.filtersCount()}
          </span>
          </button>
          <FilterFieldsPane
            isActive={this.state.showPane}
          />
        </div>
      </FilterContext.Provider>
    );
  }
}

Filter.propTypes = {
  data: PropTypes.object,
  crosstalkGroup: PropTypes.string,
}

export default Filter;
