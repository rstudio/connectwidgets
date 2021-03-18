HTMLWidgets.widget({
  name: 'rscfilter',
  type: 'output',
  factory: function(root, width, height) {
    return {
      renderValue: function(x) {
        const { el, mount } = redom;
        const content = HTMLWidgets.dataframeToD3(x.content);
        const placeholder = el("p", "placeholder for filter");
        mount(root, placeholder);
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
