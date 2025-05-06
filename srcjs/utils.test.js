import { debounce, contentImgSrc } from './utils';

jest.useFakeTimers();

describe('debounce', () => {
  it('Wraps functions in a given timing debounce', () => {
    const func = jest.fn();
    const debounceFn = debounce(500, func);

    debounceFn(123);
    expect(func).not.toHaveBeenCalled();

    jest.runAllTimers();
    expect(func).toHaveBeenCalledWith(123);
  });
});

describe('contentImgSrc', () => {
  it('builds content image src urls', () => {
    const contentUrl = 'https://connect-somewhere.com/content/1caf545c-2c45-4386-be5b-ae211fa56402/';
    const expectedImgSrc = 'https://connect-somewhere.com/content/1caf545c-2c45-4386-be5b-ae211fa56402/__thumbnail__';
    const result = contentImgSrc(contentUrl);
    expect(result).toBe(expectedImgSrc);
  });
});
