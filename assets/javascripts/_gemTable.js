import { Grid } from "gridjs";
import "gridjs/dist/theme/mermaid.css";

export default function gemTable() {
  if (document.querySelector('table#gems')) {
   new Grid({
     search: true,
     sort: true,
     from: document.querySelector('table#gems')
   }).render(document.getElementById("js-table-wrapper"));
  };
}
