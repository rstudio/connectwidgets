import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import { range } from 'lodash';
import Search from './Search';

jest.useFakeTimers();

const testFrameData = {
  // Search component only cares about name and title cols.
  name: [
    'cars-rmd-123456',
    'woodfillers-rmarkdown-123456',
    'shiny-app-987654',
    'shiny-app-159870',
    'mood-rmd-561237',
    '',
  ],
  title: [
    'Cars Report 2021',
    'Woodfillers resistance report',
    '',
    'Drying tomatoes results',
    'Colors impact in mood',
    'Research by Tommy',
  ],
};

const fulfillDebounce = () => jest.runAllTimers();

const inputEvWith = value => ({ target: { value }});

const mkWrapper = () => {
  return shallow(
    <Search
      data={testFrameData}
      crosstalkKey={range(1, testFrameData.name.length + 1)}
      crosstalkGroup="abcd-1234"
    />
  );
};

describe('<Search />', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders properly, setup crosstalk handle', () => {
    const wrapper = mkWrapper();
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(crosstalk.FilterHandle).toHaveBeenCalled();
    expect(crosstalk.FilterHandle().setGroup).toHaveBeenCalledWith('abcd-1234');
  });

  describe('while searching', () => {
    it('searching emits via crosstalk when typing debounce fullfills', () => {
      const wrapper = mkWrapper();
  
      // Won't be called immediately due to debounce
      wrapper.find('input').simulate('change', inputEvWith('horses'));
      expect(crosstalk.FilterHandle().set).not.toHaveBeenCalled();
      
      // NO rows match 'horses'
      fulfillDebounce();
      expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith([]);
    });

    it.each([
      ['shiny', [3, 4]],
      ['Tom', [4, 6]],
      ['tommy', [6]],
      ['report', [1, 2]],
      ['vegetables', []],
    ])('"%s", expects rows %s', (term, expectedRows) => {
      const wrapper = mkWrapper();
      wrapper.find('input').simulate('change', inputEvWith(term));
      fulfillDebounce();
      expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith(expectedRows);
    });

    it('crosstalk filter clears with empty search term', () => {
      const wrapper = mkWrapper();
  
      wrapper.find('input').simulate('change', inputEvWith('horses'));
      fulfillDebounce();
      expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith([]);

      wrapper.find('input').simulate('change', inputEvWith(''));
      fulfillDebounce();
      expect(crosstalk.FilterHandle().clear).toHaveBeenCalled();
    });
  });
});
