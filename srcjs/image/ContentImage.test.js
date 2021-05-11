import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import { appModeImg } from '@/appMode';
import ContentImage from './ContentImage';

jest.mock('@/appMode');
appModeImg.mockReturnValue('default-img-url');

const imageUrl = 'https://science.rstudio.com/__api__/applications/7e4bdcb4-c809-40da-9717-be86625ee690/image';
const contentUrl = 'https://science.rstudio.com/content/7e4bdcb4-c809-40da-9717-be86625ee690';

const waitForCompleteLoad = async wrapper => {
  await Promise.resolve();
  if (!wrapper.instance().state.loaded) {
    await waitForCompleteLoad(wrapper);
  }
};

const mkWrapper = async () => {
  const wrapper = shallow(<ContentImage
    imageUrl={imageUrl}
    contentUrl={contentUrl}
    contentType='Document'
  />);
  await waitForCompleteLoad(wrapper);
  return wrapper;
};

describe('<ContentImage />', () => {

  it('renders properly', async () => {
    const wrapper = await mkWrapper();
    expect(fetch).toHaveBeenCalledWith(imageUrl);
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(wrapper.instance().state.imgUrl).not.toBe('default-img-url');
  });

  describe('forbidden images', () => {
    it('uses default image and request access label shows', async () => {
      fetch.mockResolvedValueOnce({ status: 403 });
      const wrapper = await mkWrapper();
      expect(toJson(wrapper)).toMatchSnapshot();
      expect(wrapper.instance().state.imgUrl).toBe('default-img-url');
      expect(wrapper.hasClass('rscimage--no-access')).toBe(true);
    });
  });

  describe('non existent images', () => {
    it('uses default image and request access label shows', async () => {
      fetch.mockResolvedValueOnce({ status: 204 });
      const wrapper = await mkWrapper();
      expect(toJson(wrapper)).toMatchSnapshot();
      expect(wrapper.instance().state.imgUrl).toBe('default-img-url');
      expect(wrapper.hasClass('rscimage--no-access')).toBe(false);
    });
  });
});
