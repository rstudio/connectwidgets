import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import FilterFieldsPane from './FilterFieldsPane';

const fakeContext = { resetFilters: jest.fn() };
jest.spyOn(React, 'useContext').mockReturnValue(fakeContext);

const mkWrapper = () => shallow(<FilterFieldsPane isActive={false} />);

describe('<FilterFieldsPane />', () => {
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

  it('can call to reset filters state', () => {
    const wrapper = mkWrapper();
    expect(fakeContext.resetFilters).not.toHaveBeenCalled();
    wrapper.find('button').simulate('click');
    expect(fakeContext.resetFilters).toHaveBeenCalled();
  });
});
