import { Grid, html } from "gridjs";
import "gridjs/dist/theme/mermaid.css";

export default function gemTable() {
  if (document.getElementById('gems-table')) {
    new Grid({
      search: true,
      sort: true,
      columns: [
        'Popularity',
        {
          name: 'Name',
          formatter: (info) => html(`<a class="gem-name" href="${info.path}">${info.name}</a>`),
          sort: {
            // Default comparison fails because it's rendered as HTML.
            compare: (a, b) => {
              if (a.name > b.name) {
                return 1;
              } else if (b.name > a.name) {
                return -1;
              } else {
                return 0;
              }
            }
          }
        },
        'Description',
        'Category',
        {
          name: 'App appropriate?',
          formatter: (appAppropriate) => (appAppropriate && "👍")
        }
      ],
      server: {
       url: "/gems.json",
       then: data => data.map(
          gem => [
            gem.popularity,
            {name: gem.name, path: gem.path},
            gem.description,
            gem.category,
            gem.app_appropriate
          ]
        )
      },
    }).render(document.getElementById("gems-table"));
  };
}
