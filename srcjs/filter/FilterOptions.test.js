import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import FilterOptions from './FilterOptions';
import { FilterType } from './filterType';

const data = [
  {
    name: 'API',
    label: 'API',
    isSelected: false,
  },
  {
    name: 'Application',
    label: 'Application',
    isSelected: false,
  },
  {
    name: 'Document',
    label: 'Document',
    isSelected: false,
  },
  {
    name: 'Model',
    label: 'Model',
    isSelected: false,
  },
  {
    name: 'Pin',
    label: 'Pin',
    isSelected: false,
  },
];
const onCheckboxBlurMock = jest.fn();
const fakeContext = {
  options: { [FilterType.type]: data },
  stateOptionsFor: jest.fn().mockImplementation(() => data),
  updateSelection: jest.fn(),
};
jest.spyOn(React, 'useContext').mockReturnValue(fakeContext);

const mkWrapper = () => shallow(<FilterOptions
  type={FilterType.type}
  onCheckboxBlur={onCheckboxBlurMock}
/>);

describe('<FilterOptions />', () => {
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
  
  it('emits changes to context/state', () => {
    const wrapper = mkWrapper();
    const options = wrapper.find('.rscfilter-option');
    
    expect(fakeContext.updateSelection).not.toHaveBeenCalled();
    options.at(1).simulate('click', {});
    expect(fakeContext.updateSelection).toHaveBeenCalledWith({
      name: 'Application',
      label: 'Application',
      isSelected: true,
    });

    options.at(4).simulate('click', {});
    expect(fakeContext.updateSelection).toHaveBeenCalledWith({
      name: 'Pin',
      label: 'Pin',
      isSelected: true,
    });
  });
});
