import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import { range } from 'lodash';
import Filter from './Filter';
import FilterFieldsPane from './FilterFieldsPane';
import { FilterType } from './filterType';

const testFrameData = {
  // Filter component only needs this columns data.
  owner_username: [
    'jzcarpenter',
    'reporterfrank',
    'automata',
    'reporterfrank',
    'jzcarpenter',
    'reporterfrank',
    'autoreporter009',
    'brucebowtie',
  ],
  app_mode: [
    'rmd-static',   // Document
    'python-api',   // API
    'python-dash',  // Application
    'shiny',        // Application
    'rmd-static',   // Document
    'static',       // Pin
    'api',          // API
    'python-dash',  // Application
  ],
  content_category: [
    '',
    '',
    '',
    '',
    '',
    'pin',
    '',
  ],
  tags: [
    { name: ["vegetables", "carrot", "vitamin D"] },
    { name: "orange" },
    { name: ["fruits", "orange"] },
    { name: ["nutrition", "vitamin B", "vitamin D"] },
    { name: "watermelon" },
    { name: ["fruits", "strawberry"] },
    { name: ["other", "minerals", "zinc"] },
    { name: ["distros", "alpine"] },
  ],
};

/**
 * Expected filter options provided by parsed data
 * owner: ['automata' 'autoreporter009' 'brucebowtie' 'jzcarpenter' 'reporterfrank']
 * type: ['Document', 'API', 'Application', 'Pin']
 * tag: ['alpine' 'carrot' 'distros' 'fruits' 'minerals' 'nutrition' 'orange' 'other' 'strawberry' 'vegetables' 'vitamin B' 'vitamin D' 'watermelon' 'zinc']
 */

const mkWrapper = () => shallow(
  <Filter
    data={testFrameData}
    crosstalkKey={range(1, testFrameData.app_mode.length + 1)}
    crosstalkGroup="abcd-1234"
  />
);

describe('<Filter />', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders properly, setup state and crosstalk handle', () => {
    const wrapper = mkWrapper();
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(crosstalk.FilterHandle).toHaveBeenCalled();
    expect(crosstalk.FilterHandle().setGroup).toHaveBeenCalledWith('abcd-1234');
  });

  it('toggle pane', () => {
    const wrapper = mkWrapper();
    const button = () => wrapper.find('button');
    const pane = () => wrapper.find(FilterFieldsPane);

    expect(pane().props().isActive).toBe(false);

    button().simulate('click');
    expect(pane().props().isActive).toBe(true);

    button().simulate('click');
    expect(pane().props().isActive).toBe(false);
  });

  it('searchFieldOptions(), pre-filter options with the given term', () => {
    const wrapper = mkWrapper();
    const optsState = type => wrapper.state().stateOptionsFor(type);
    const ownerOptsState = () => optsState(FilterType.owner);
    const typeOptsState = () => optsState(FilterType.type);
    const tagsOptsState = () => optsState(FilterType.tag);

    wrapper.instance().searchFieldOptions(FilterType.owner, 'ter');
    expect(ownerOptsState().length).toBe(3);
    expect(ownerOptsState()[0].name).toBe('autoreporter009');
    expect(ownerOptsState()[1].name).toBe('jzcarpenter');
    expect(ownerOptsState()[2].name).toBe('reporterfrank');
    
    wrapper.instance().searchFieldOptions(FilterType.owner, 'auto');
    expect(ownerOptsState().length).toBe(2);
    expect(ownerOptsState()[0].name).toBe('automata');
    expect(ownerOptsState()[1].name).toBe('autoreporter009');

    wrapper.instance().searchFieldOptions(FilterType.owner, 'bruce');
    expect(ownerOptsState().length).toBe(1);
    expect(ownerOptsState()[0].name).toBe('brucebowtie');
    
    wrapper.instance().searchFieldOptions(FilterType.owner, '');
    expect(ownerOptsState().length).toBe(5);

    wrapper.instance().searchFieldOptions(FilterType.type, 'a');
    expect(typeOptsState().length).toBe(2);
    expect(typeOptsState()[0].name).toBe('API');
    expect(typeOptsState()[1].name).toBe('Application');

    wrapper.instance().searchFieldOptions(FilterType.type, 'doc');
    expect(typeOptsState().length).toBe(1);
    expect(typeOptsState()[0].name).toBe('Document');

    wrapper.instance().searchFieldOptions(FilterType.type, 'report');
    expect(typeOptsState().length).toBe(0);

    wrapper.instance().searchFieldOptions(FilterType.type, '');
    expect(typeOptsState().length).toBe(4);

    wrapper.instance().searchFieldOptions(FilterType.tag, 'vit');
    expect(tagsOptsState().length).toBe(2);
    expect(tagsOptsState()[0].name).toBe('vitamin B');
    expect(tagsOptsState()[1].name).toBe('vitamin D');

    wrapper.instance().searchFieldOptions(FilterType.tag, 'mine');
    expect(tagsOptsState().length).toBe(1);
    expect(tagsOptsState()[0].name).toBe('minerals');

    wrapper.instance().searchFieldOptions(FilterType.tag, '');
    expect(tagsOptsState().length).toBe(14);
  });

  it('updateSelection(), updates selected filters state and emits crosstalk event', () => {
    let expectedRows = [];
    const wrapper = mkWrapper();
    
    expectedRows = [2, 4, 6];
    wrapper.instance().updateSelection({
      name: 'reporterfrank',
      isSelected: true,
      filterType: FilterType.owner,
      applicableRows: [1, 3, 5],
    });
    expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith(expectedRows);

    expectedRows = [2];
    wrapper.instance().updateSelection({
      name: 'API',
      isSelected: true,
      filterType: FilterType.type,
      applicableRows: [1, 6],
    });
    expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith(expectedRows);

    expectedRows = [2, 7];
    wrapper.instance().updateSelection({
      name: 'autoreporter009',
      isSelected: true,
      filterType: FilterType.owner,
      applicableRows: [6],
    });
    expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith(expectedRows);

    expectedRows = [2, 4, 6, 7];
    wrapper.instance().updateSelection({
      name: 'API',
      isSelected: false,
      filterType: FilterType.type,
      applicableRows: [1, 6],
    });
    expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith(expectedRows);

    expectedRows = [7];
    wrapper.instance().updateSelection({
      name: 'reporterfrank',
      isSelected: false,
      filterType: FilterType.owner,
      applicableRows: [1, 3, 5],
    });
    expect(crosstalk.FilterHandle().set).toHaveBeenCalledWith(expectedRows);

    // Remove the last selected filter clears handle
    wrapper.instance().updateSelection({
      name: 'autoreporter009',
      isSelected: false,
      filterType: FilterType.owner,
      applicableRows: [6],
    });
    expect(crosstalk.FilterHandle().clear).toHaveBeenCalled();
  });

  it('resetFilters(), resets state and emits crosstalk clear', () => {
    const wrapper = mkWrapper();

    wrapper.instance().updateSelection({
      name: 'reporterfrank',
      isSelected: true,
      filterType: FilterType.owner,
      applicableRows: [1, 3, 5],
    });

    wrapper.instance().updateSelection({
      name: 'jzcarpenter',
      isSelected: true,
      filterType: FilterType.owner,
      applicableRows: [0, 4],
    });

    wrapper.instance().updateSelection({
      name: 'Document',
      isSelected: true,
      filterType: FilterType.type,
      applicableRows: [0, 4],
    });

    expect(wrapper.instance().hasFiltersSelected()).toBe(true);

    wrapper.instance().resetFilters();
    expect(wrapper.instance().hasFiltersSelected()).toBe(false);
    expect(crosstalk.FilterHandle().clear).toHaveBeenCalled();
  });
});
