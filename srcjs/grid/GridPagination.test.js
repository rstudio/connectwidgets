import { expect, it } from '@jest/globals';
import { shallow } from 'enzyme';
import toJson from 'enzyme-to-json';
import GridPagination from './GridPagination';

let wrapper;
const onChangeFn = jest.fn().mockImplementation(page => {
  wrapper.setProps({ currentPage: page });
});

const mkWrapper = () => {
  wrapper = shallow(<GridPagination
    total={63}
    perPage={12}
    currentPage={1}
    onChange={onChangeFn}
  />);
};

describe('<GridPagination />', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('renders properly', () => {
    mkWrapper();
    const pagesBtns = wrapper.find('.rscgrid-pagination__btn');
    expect(toJson(wrapper)).toMatchSnapshot();
    expect(pagesBtns.length).toBe(8);
    expect(pagesBtns.at(1).hasClass('rscgrid-pagination__btn--current')).toBe(true);
  });
  
  it('onChange: navigates and highlights the current page as expected', () => {
    mkWrapper();
    const pagesBtns = () => wrapper.find('.rscgrid-pagination__btn');
    expect(pagesBtns().at(0).prop('disabled')).toBe(true);

    // hit next page
    pagesBtns().at(7).simulate('click');
    expect(onChangeFn).toHaveBeenCalledWith(2);
    expect(pagesBtns().at(0).prop('disabled')).toBe(false);
    expect(pagesBtns().at(2).hasClass('rscgrid-pagination__btn--current')).toBe(true);

    // hit fourth page
    pagesBtns().at(4).simulate('click');
    expect(onChangeFn).toHaveBeenCalledWith(4);
    expect(pagesBtns().at(0).prop('disabled')).toBe(false);
    expect(pagesBtns().at(7).prop('disabled')).toBe(false);
    expect(pagesBtns().at(4).hasClass('rscgrid-pagination__btn--current')).toBe(true);

    // hit previous page
    pagesBtns().at(0).simulate('click');
    expect(onChangeFn).toHaveBeenCalledWith(3);
    expect(pagesBtns().at(0).prop('disabled')).toBe(false);
    expect(pagesBtns().at(7).prop('disabled')).toBe(false);
    expect(pagesBtns().at(3).hasClass('rscgrid-pagination__btn--current')).toBe(true);

    // hit last page
    pagesBtns().at(6).simulate('click');
    expect(onChangeFn).toHaveBeenCalledWith(6);
    expect(pagesBtns().at(0).prop('disabled')).toBe(false);
    expect(pagesBtns().at(7).prop('disabled')).toBe(true);
    expect(pagesBtns().at(6).hasClass('rscgrid-pagination__btn--current')).toBe(true);
  });
});
