import PropTypes from 'prop-types';
import { FilterContext } from './stateUtils';
import './filterOptions.scss';

const optionsClass = {
  base: 'rscfilter-field__options',
  show: 'rscfilter-field__options rscfilter-field__options--show',
};

const checkboxClass = {
  base: 'rscfilter-option__checkbox',
  checked: 'rscfilter-option__checkbox rscfilter-option__checkbox--checked',
};

function FilterOptions({ type, show, onCheckboxBlur }) {
  const context = React.useContext(FilterContext);
  const options = context.stateOptionsFor(type);
  const componentClass = show ? optionsClass.show : optionsClass.base;

  const handleCheckbox = (ev, index) => {
    // Space key press is the standard to toggle checkboxes
    if(ev.key && ev.code !== 'Space') {
      return;
    }
    context.updateSelection({
      ...options[index],
      isSelected: !options[index].isSelected,
    });
  };

  const handleEsc = ev => {
    if (ev.key === "Escape") {
      ev.stopPropagation();
      document.activeElement.blur();
    }
  }

  return (
    <div className={componentClass}>
      {
        options.map((option, index) => {
          const chClass = option.isSelected ? checkboxClass.checked : checkboxClass.base;
          return (
            <div
              key={option.name}
              className="rscfilter-option"
              onClick={ev => handleCheckbox(ev, index)}
              onKeyUp={handleEsc}
              onKeyPress={ev => handleCheckbox(ev, index)}
              onBlur={onCheckboxBlur}
              role="checkbox"
              aria-checked={option.isSelected}
              tabIndex="0"
            >
              <div className={chClass} />
              <span>
                {option.label}
              </span>
            </div>
          );
        })
      }
    </div>
  );
}

FilterOptions.propTypes = {
  type: PropTypes.string,
  show: PropTypes.bool,
  onCheckboxBlur: PropTypes.func,
}

export default FilterOptions;
