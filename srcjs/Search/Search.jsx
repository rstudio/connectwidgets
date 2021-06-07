/**
 * rscsearch main component
 * React provided at window via reactR
 */

import { cloneDeep } from 'lodash';
import PropTypes from 'prop-types';
import { debounce } from '@/utils';
import './search.scss';

class Search extends React.Component {
  constructor(props) {
    super(props);
    const crosstalkHandle = new crosstalk.FilterHandle();
    crosstalkHandle.setGroup(props.crosstalkGroup);

    const dataKeys = Array.isArray(props.crosstalkKey)
                      ? props.crosstalkKey
                      : props.data[props.crosstalkKey];

    this.state = {
      data: cloneDeep(props.data),
      dataKeys,
      crosstalkHandle,
    };

    this.search = debounce(300, this.search.bind(this));
    this.onInputChange = this.onInputChange.bind(this);
  }

  onInputChange(ev) {
    const prefix = ev.target.value.trim();
    this.search(prefix);
  }

  search(prefix) {
    if (prefix === "") {
      this.state.crosstalkHandle.clear();
      return;
    }

    const regx = new RegExp(prefix, "i");
    const results = this.state.data.title.reduce((matching, title, index) => {
      if (regx.test(title) || regx.test(this.state.data.name[index])) {
        // dataframe rows start at 1 and aren't based on index 0
        matching.push(this.state.dataKeys[index]);
      }
      return matching;
    }, []);

    this.state.crosstalkHandle.set(results);
  }

  render() {
    return (
      <div className="rscsearch">
        <input
          className="rscsearch__input"
          type="text"
          placeholder="Search"
          onChange={this.onInputChange}
        />
      </div>
    );
  }
}

Search.propTypes = {
  data: PropTypes.object,
  crosstalkKey: PropTypes.array,
  crosstalkGroup: PropTypes.string,
}

export default Search;
