import PropTypes from 'prop-types';
import { debounce } from '@/utils';
import FilterOptions from './FilterOptions';
import FiltersSelected from './FiltersSelected';
import { FilterType } from './filterType';
import { FilterContext } from './stateUtils';
import './filterField.scss';

const fieldClass = {
  base: 'rscfilter-field__input-wrap',
  dropdown: 'rscfilter-field__input-wrap rscfilter-field__input-wrap--dropdown',
};

function FilterField({ label, placeholder, type }) {
  const inputRef = React.createRef();

  const context = React.useContext(FilterContext);
  const isDropdown = type === FilterType.type;

  const prefilteringHandler = ev => {
    const prefix = ev.target.value.trim();
    context.searchFieldOptions(type, prefix);
  }

  const handleEsc = ev => {
    if (ev.key === "Escape") {
      ev.stopPropagation();
      inputRef.current.blur();
    }
  }

  return (
    <div className="rscfilter-field">
      <div className={isDropdown ? fieldClass.dropdown : fieldClass.base}>
        <label className="rscfilter-field__name">{label}</label>
        <input
          className="rscfilter-field__input"
          ref={inputRef}
          name={type}
          placeholder={placeholder}
          onChange={debounce(300, prefilteringHandler)}
          onKeyUp={handleEsc}
        />
        <FilterOptions type={type} />
      </div>
      <FiltersSelected type={type} />
    </div>
  );
}

FilterField.propTypes = {
  type: PropTypes.string,
  label: PropTypes.string,
  placeholder: PropTypes.string,
}

export default FilterField;
