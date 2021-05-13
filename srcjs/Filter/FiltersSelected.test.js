import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import FiltersSelected from './FiltersSelected';
import { FilterType } from './filterType';

const data = [
  {
    name: 'API',
    label: 'API',
    isSelected: true,
  },
  {
    name: 'Application',
    label: 'Application',
    isSelected: true,
  },
  {
    name: 'Document',
    label: 'Document',
    isSelected: true,
  },
];
const fakeContext = {
  selections: { [FilterType.type]: data },
  stateSelectionsFor: jest.fn().mockImplementation(() => data),
  updateSelection: jest.fn(),
};
jest.spyOn(React, 'useContext').mockReturnValue(fakeContext);

const mkWrapper = () => shallow(<FiltersSelected type={FilterType.type} />);

describe('<FiltersSelected />', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  afterAll(() => {
    jest.restoreAllMocks();
  });

  it('renders properly', () => {
    const wrapper = mkWrapper();
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(wrapper.find('.rscfilter-selections__item').length).toBe(3);
  });
  
  it('emits changes to context/state', () => {
    const wrapper = mkWrapper();
    const selections = wrapper.find('.rscfilter-selections__item');
    
    expect(fakeContext.updateSelection).not.toHaveBeenCalled();
    selections.at(1).find('.rscfilter-selections__item-discard').simulate('click', {});
    expect(fakeContext.updateSelection).toHaveBeenCalledWith({
      name: 'Application',
      label: 'Application',
      isSelected: false,
    });

    selections.at(2).find('.rscfilter-selections__item-discard').simulate('click', {});
    expect(fakeContext.updateSelection).toHaveBeenCalledWith({
      name: 'Document',
      label: 'Document',
      isSelected: false,
    });
  });
});
