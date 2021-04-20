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
