HTMLWidgets.widget({
  name: 'rscpages',
  type: 'output',
  factory: function(root, width, height) {
    const appModes = {
      'unknown': 'Unknown',
    };

    const formatDate = (dateString) => {
      const options = { year: "numeric", month: "long", day: "numeric" };
      return new Date(dateString).toLocaleDateString(undefined, options);
    };

    const formatCategory = (appMode, contentCategory) => {
      switch(appMode) {
        case 'shiny':
          return 'Shiny application';
        case 'rmd-shiny':
          return 'Shiny document';
        case 'rmd-static':
          return contentCategory == 'site' ? 'Site' : 'Rmarkdown document';
        case 'static':
          switch(contentCategory) {
            case 'site': return 'Site';
            case 'pin': return 'Pin';
            case 'plot': return 'Plot';
            default: return 'Static';
          }
        case 'api':
        case 'python-api':
          return 'API';
        case 'tensorflow-saved-model':
          return 'TensorFlow Model API';
        case 'jupyter-static':
          return 'Jupyter notebook';
        case 'python-dash':
          return 'Dash application';
        case 'python-streamlit':
          return 'Streamlit application';
        case 'python-bokeh':
          return 'Bokeh application';
        default:
          return 'Unknown';
      }
    };

    return {
      renderValue: function(x) {
        const { el, mount } = redom;

        const content = HTMLWidgets.dataframeToD3(x.content);

        const table = el("table.rscpages-table", [
          el("thead",
            el("tr.rscpages-table__row.rscpages-table__row-head", [
              el("th.rscpages-table__cell", "Name"),
              el("th.rscpages-table__cell", "Type"),
              el("th.rscpages-table__cell", "Updated"),
            ])
          ),
          el("tbody", content.map((item) => {
            var row =  el('tr.rscpages-table__row.rscpages-table__row-body', [
              el("td.rscpages-table__cell.rscpages-table__cell-name", item.name),
              el("td.rscpages-table__cell.rscpages-table__cell-type", formatCategory(item.app_mode, item.content_category)),
              el("td.rscpages-table__cell.rscpages-table__cell-updated",
                el("time", { datetime: item.updated_time }, formatDate(item.updated_time))
              ),
            ]);

            row.onclick = () => window.open(item.url, '_blank');

            return row;
          }))
        ]);

        mount(root, table);
      },

      resize: function(width, height) {
        // TODO: code to re-render the widget with a new size
      }
    };
  }
});
