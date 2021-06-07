import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import GridView from './GridView';
import GridPagination from './GridPagination';
import testFrameData from './test-fixtures/data.json'

const mkWrapper = (data = testFrameData) => {
  return shallow(<GridView
    data={data}
    crosstalkGroup="abcd-1234"
  />);
};

describe('<GridView />', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders properly, setup state and crosstalk handle', () => {
    const wrapper = mkWrapper();
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(crosstalk.FilterHandle).toHaveBeenCalled();
    expect(crosstalk.FilterHandle().setGroup).toHaveBeenCalledWith('abcd-1234');
  });

  describe('when filtering is notified via crosstalk', () => {
    it('with results, shows the applicable items', () => {
      const wrapper = mkWrapper();
      expect(wrapper.find('.rscgrid-item').length).toBe(12);

      wrapper.instance().onFilterChange({ value: [4, 10, 23, 29, 54] });
      expect(wrapper.find('.rscgrid-item').length).toBe(5);
    });

    it('managing subsets, shows the applicable items and discards non existent items', () => {
      const wrapper = mkWrapper();
      expect(wrapper.find('.rscgrid-item').length).toBe(12);

      wrapper.instance().onFilterChange({ value: [4, 10, 23, 1000, 1002, 1005] });
      expect(wrapper.find('.rscgrid-item').length).toBe(3);
    });

    it('with empty results, shows "no content found"', () => {
      const wrapper = mkWrapper();
      expect(wrapper.find('.rscgrid-item').length).toBe(12);

      wrapper.instance().onFilterChange({ value: [] });
      expect(wrapper.find('.rscgrid-item').length).toBe(0);
      expect(wrapper.find('.rscgrid__grid').text()).toBe('No content found');
    });

    it('with null results, that is a reset', () => {
      const wrapper = mkWrapper();
      expect(wrapper.find('.rscgrid-item').length).toBe(12);

      wrapper.instance().onFilterChange({ value: [] });
      expect(wrapper.find('.rscgrid-item').length).toBe(0);

      // reset/discard filters
      wrapper.instance().onFilterChange({ value: null });
      expect(wrapper.find('.rscgrid-item').length).toBe(12);
    });
  });

  describe('when navigating through pages', () => {
    // See test-fixtures/data.json
    let wrapper;
    const pageItems = () => wrapper.find('.rscgrid-item');
    const titleOf = index => pageItems().at(index).find('.rscgrid-item__title').text();

    it('shows the content items for that page', () => {
      wrapper = mkWrapper();
      expect(titleOf(0)).toBe('methodical synergize');
      expect(titleOf(11)).toBe('Cambodia');

      wrapper.instance().paginate(2);
      expect(titleOf(0)).toBe('Guernsey');
      expect(titleOf(11)).toBe('Enterprise-wide New Lead');

      wrapper.instance().paginate(4);
      expect(titleOf(0)).toBe('gold engage');
      expect(titleOf(11)).toBe('United interface');
    });

    it('on filtering, goes to first page', () => {
      wrapper = mkWrapper();
      wrapper.instance().paginate(4);
      expect(titleOf(0)).toBe('gold engage');
      expect(titleOf(11)).toBe('United interface');

      wrapper.instance().onFilterChange({ value: [4, 10, 23, 29, 54] });
      expect(wrapper.instance().state.currentPage).toBe(1);
      expect(titleOf(0)).toBe('Gardens Consultant');
      expect(titleOf(4)).toBe('e-enable invoice');
    });

    it('pagination only shows when there is more than 1 page', () => {
      const dataKeys = [
        'url', 'guid', 'title', 'name',
        'owner_username', 'updated_time'
      ];
      const smallDataSample = {};
      dataKeys.forEach(key => {
        smallDataSample[key] = testFrameData[key].slice(0,8);
      });
      wrapper = mkWrapper(smallDataSample);
      expect(wrapper.find(GridPagination).exists()).toBe(false);

      wrapper = mkWrapper();
      expect(wrapper.find(GridPagination).exists()).toBe(true);
    });
  });
});
