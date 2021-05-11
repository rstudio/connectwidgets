import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import FilterField from './FilterField';
import { FilterType } from './filterType';

jest.useFakeTimers();

const fulfillDebounce = () => jest.runAllTimers();
const inputEvWith = value => ({ target: { value }});
const fakeContext = {
  options: { [FilterType.owner]: [{
      name: 'admin',
      label: 'admin',
      isSelected: false,
    }]
  },
  searchFieldOptions: jest.fn(),
  updateSelection: jest.fn(),
};
jest.spyOn(React, 'useContext').mockReturnValue(fakeContext);

const mkWrapper = () => shallow(<FilterField label="Owner" placeholder="Filter people" type={FilterType.owner} />);

describe('<FilterField />', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  afterAll(() => {
    jest.restoreAllMocks();
  });

  it('renders properly', () => {
    const wrapper = mkWrapper();
    expect(toJson(wrapper)).toMatchSnapshot();
  });

  it('search field options on change and after debounce', () => {
    const wrapper = mkWrapper();

    wrapper.find('input').simulate('change', inputEvWith('tommy'));
    expect(fakeContext.searchFieldOptions).not.toHaveBeenCalled();

    fulfillDebounce();
    expect(fakeContext.searchFieldOptions).toHaveBeenCalledWith(FilterType.owner, 'tommy');
  });
});
