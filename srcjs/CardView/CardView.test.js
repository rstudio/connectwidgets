import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import CardView from './CardView';

// Object format frame-like that comes from R
const dataExpecetdFormat = {
  url: ['https://connect.tester.net/content/991f16c5-dc7e-4403-89d0-c54d10968460/'],
  guid: ['991f16c5-dc7e-4403-89d0-c54d10968460'],
  owner_username: ['Porter_Terry'],
  title: ['methodical synergize'],
  name: ['methodical-synergize'],
  description: ['Lorem ipsum dolor sit amet'],
  updated_time: ['Fri Oct 30 2020 06:18:46 GMT'],
}

describe('<CardView />', () => {

  // Snapshot testing is enough for this component
  // as it doesn't bring anything other than presentation

  it('renders properly', () => {
    const wrapper = shallow(<CardView data={dataExpecetdFormat} />);
    expect(toJson(wrapper)).toMatchSnapshot();
  });
});
