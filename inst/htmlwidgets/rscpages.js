HTMLWidgets.widget({
  name: 'rscpages',
  type: 'output',
  factory: function(root, width, height) {
    return {
      renderValue: function(x) {
        const { el, mount } = redom;

        const content = HTMLWidgets.dataframeToD3(x.content);

        const table = el("table.rscpages-table", [
          el("thead",
            el("tr.rscpages-table__head-row", [
              el("th.rscpages-table__head-cell", "Name"),
              el("th.rscpages-table__head-cell", "Type"),
              el("th.rscpages-table__head-cell", "Updated"),
            ])
          ),
          el("tbody", content.map((item) => {
            return el('tr.rscpages-table__row', [
              el("td.rscpages-table__cell", el("a", { target: "blank", href: item.url }, item.name)),
              el("td.rscpages-table__cell", "todo"),
              el("td.rscpages-table__cell", "todo"),
            ]);
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
