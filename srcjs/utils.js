/**
 * Debounce a function.
 * @param {number} delay Debounce delay to execution.
 * @param {Function} fn Function to execute after delay.
 */
export function debounce(delay, fn) {
  let timeoutID = null;
  return function() {
    clearTimeout(timeoutID);
    const args = arguments;
    const that = this;
    timeoutID = setTimeout(function() {
      fn.apply(that, args);
    }, delay);
  };
}

/**
 * Get the image src url for content
 * @param {string} contentUrl GUID based content url
 * @param {string} guid  content GUID
 * @returns Image src url
 */
export function contentImgSrc(contentUrl) {
  // Just append __thumbnail__ to the content url
  return contentUrl + '__thumbnail__';
}
