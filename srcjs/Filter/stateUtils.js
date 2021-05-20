import { appTypeOf } from '@/appMode';
import { FilterType } from './filterType';

const { createContext } = window.React;

const filterOptionFactory = (dataIndex, filterType, filterName, filterLabel) => {
  return {
    name: filterName,
    label: filterLabel || filterName,
    isSelected: false,
    filterType: filterType,
    // dataframe rows start at 1 and aren't based on index 0
    applicableRows: [ dataIndex + 1 ],
  };
}

/**
 * Create a new filters state object.
 * @returns {Object} Shallow filters state object.
 */
export const shallowFiltersState = () => ({
  [FilterType.owner]: [],
  [FilterType.type]: [],
  [FilterType.tag]: [],
});

/**
 * Parse the widget's DataFrame data to unique filter options.
 * @param {Object} allData Data object from the widget.
 * @returns {Object} Parsed filter options ({ owner, type, tag }).
 */
export const parseDataToFilters = allData => {
  const filtersReducer = type => (collection, item, index) => {
    if (!(item in collection)) {
      collection[item] = filterOptionFactory(index, type, item);
    } else {
      // dataframe rows start at 1 and aren't based on index 0 (thus index + 1)
      collection[item].applicableRows.push(index + 1);
    }
    return collection;
  };

  const appModeReducer = type => (collection, item, index) => {
    const label = appTypeOf(item, allData.content_category[index]);
    return filtersReducer(type)(collection, label, index);
  };

  const tagsReducer = type => (collection, item, index) => {
    if (!item) {
      return collection;
    }
    if (Array.isArray(item.name)) {
      item.name.forEach(tagInTree => {
        collection = filtersReducer(type)(collection, tagInTree, index);
      });
    } else {
      collection = filtersReducer(type)(collection, item.name, index);
    }
    return collection;
  };

  const dataToUniqueFilters = (columnData, type) => {
    let reducer = filtersReducer;
    if (type === FilterType.type) {
      reducer = appModeReducer;
    }
    if (type === FilterType.tag) {
      reducer = tagsReducer;
    }
    const uniqueFilters = columnData.reduce(reducer(type), {});
    return Object.values(uniqueFilters)
                  .sort((a, b) => {
                    return a.label.localeCompare(b.label, 'en', { sensitivity: 'base' });
                  })
                  .map((fltr, index) => {
                    fltr.index = index;
                    return fltr;
                  });
  }

  return {
    [FilterType.owner]: dataToUniqueFilters(allData.owner_username, FilterType.owner),
    [FilterType.type]: dataToUniqueFilters(allData.app_mode, FilterType.type),
    [FilterType.tag]: dataToUniqueFilters(allData.tags, FilterType.tag),
  };
};

/**
 * Generate the context for the filter component.
 * @returns The context/state to be used by the filter component.
 */
export const FilterContext = createContext({
  showPane: false,
  crosstalkHandle: null,
  options: shallowFiltersState(),
  selections: shallowFiltersState(),
  stateOptionsFor: () => {},
  stateSelectionsFor: () => {},
  searchFieldOptions: () => {},
  updateSelection: () => {},
  resetFilters: () => {},
});
