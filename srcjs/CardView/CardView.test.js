import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import CardView from './CardView';

// Object format frame-like that comes from R
const dataSingleItem = {
  url: ['https://connect.tester.net/content/991f16c5-dc7e-4403-89d0-c54d10968460/'],
  guid: ['991f16c5-dc7e-4403-89d0-c54d10968460'],
  owner_username: ['Porter_Terry'],
  title: ['methodical synergize'],
  name: ['methodical-synergize'],
  description: ['Lorem ipsum dolor sit amet'],
  updated_time: ['Fri Oct 30 2020'],
}

// Object format frame-like that comes from R
const dataMultipleItems = {
  url: [
    'https://connect.tester.net/content/991f16c5-dc7e-4403-89d0-c54d10968460/',
    'https://connect.tester.net/content/c2bd6807-cb2f-4683-865b-107cf37eddf6/',
    'https://connect.tester.net/content/ea731b93-458f-4552-becf-b2e0ce552e3d/',
  ],
  guid: [
    '991f16c5-dc7e-4403-89d0-c54d10968460',
    'c2bd6807-cb2f-4683-865b-107cf37eddf6',
    'ea731b93-458f-4552-becf-b2e0ce552e3d',
  ],
  owner_username: [
    'Porter_Terry',
    'Navarro.BigBand',
    'Bob.C.Martin',
  ],
  title: [
    'methodical synergize',
    'incredible peanuts',
    'clean coder',
  ],
  name: [
    'methodical-synergize',
    'incredible peanuts',
    'clean coder',
  ],
  description: [
    'Lorem ipsum dolor sit amet',
    'Maecenas more than ipsum and three dogs',
    'a book on the shelve',
  ],
  updated_time: [
    'Fri Oct 30 2020',
    'Wed Sep 16 2020',
    'Mon Sep 21 2020',
  ],
}

describe('<CardView />', () => {

  // Snapshot testing is enough for this component
  // as it doesn't bring anything other than presentation

  it('single item render properly', () => {
    const wrapper = shallow(<CardView data={dataSingleItem} />);
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(wrapper.find('.rsccard__card').length).toBe(1);
  });

  it('mutliple items render properly', () => {
    const wrapper = shallow(<CardView data={dataMultipleItems} />);
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(wrapper.find('.rsccard__card').length).toBe(3);
  });
});
