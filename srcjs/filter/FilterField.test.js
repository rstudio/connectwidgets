import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import FilterField from './FilterField';
import FilterOptions from './FilterOptions';
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

  it('focus/blur input, shows and hides filter options', () => {
    const wrapper = mkWrapper();
    const optsWrapper = () => wrapper.find(FilterOptions);

    expect(optsWrapper().props().show).toBe(false);

    wrapper.find('input').simulate('focus');
    expect(optsWrapper().props().show).toBe(true);

    wrapper.find('input').simulate('blur', { relatedTarget: null });
    expect(optsWrapper().props().show).toBe(false);
  });

  describe('simulate blur from checkbox', () => {
    it('focus on another element, hides field options', () => {
      const wrapper = mkWrapper();
      const optsWrapper = () => wrapper.find(FilterOptions);

      wrapper.find('input').simulate('focus');
      expect(optsWrapper().props().show).toBe(true);

      wrapper.find(FilterOptions).props().onCheckboxBlur({
        relatedTarget: { name: 'tags', classList: { contains: () => {} } },
      });
      expect(optsWrapper().props().show).toBe(false);
    });

    it('focus on checkbox in same field, keeps options open', () => {
      const wrapper = mkWrapper();
      const optsWrapper = () => wrapper.find(FilterOptions);

      wrapper.find('input').simulate('focus');
      expect(optsWrapper().props().show).toBe(true);

      wrapper.find(FilterOptions).props().onCheckboxBlur({
        // forcing classlist to contain checkbox class
        relatedTarget: { classList: { contains: () => true } },
      });
      expect(optsWrapper().props().show).toBe(true);
    });
  });

  it('search field options on change and after debounce', () => {
    const wrapper = mkWrapper();

    wrapper.find('input').simulate('change', inputEvWith('tommy'));
    expect(fakeContext.searchFieldOptions).not.toHaveBeenCalled();

    fulfillDebounce();
    expect(fakeContext.searchFieldOptions).toHaveBeenCalledWith(FilterType.owner, 'tommy');
  });
});
