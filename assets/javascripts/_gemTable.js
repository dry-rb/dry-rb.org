import { Grid, html } from "gridjs";
import "gridjs/dist/theme/mermaid.css";

export default function gemTable() {
  if (document.getElementById('gems-table')) {
   new Grid({
     search: true,
     sort: true,
     columns: [
       {
         name: 'Name',
         formatter: (info) => html(`<a href="${info.path}">${info.name}</a>`)
      },
       'Description',
       'Category',
       'Popularity',
       {
         name: 'High level?',
         formatter: (isHighLevel) => (isHighLevel && "👍")
       }
     ],
     server: {
      url: "http://localhost:4567/gems.json",
      then: data => data.map(
         gem => [
           {name: gem.name, path: gem.path},
           gem.description,
           gem.category,
           gem.popularity,
           gem.is_high_level
         ]
       )
     }
   }).render(document.getElementById("gems-table"));
  };
}
