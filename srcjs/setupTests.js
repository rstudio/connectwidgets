import React from 'react';
import Enzyme from 'enzyme';
import Adapter from '@wojtekmaj/enzyme-adapter-react-17';
Enzyme.configure({ adapter: new Adapter() });

/**
 * Mock crosstalk and filter handle.
 */
const filterHandleMock = {
  setGroup: jest.fn(),
  clear: jest.fn(),
  set: jest.fn(),
};

global.crosstalk = {
  FilterHandle: jest.fn().mockImplementation(() => filterHandleMock),
};

/**
 * Provide React globally as it is provided by reactR like this.
 */
global.React = React;
