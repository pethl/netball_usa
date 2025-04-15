import { Controller } from "@hotwired/stimulus"
import Plotly from "plotly.js-dist-min" // ✅ double check this

export default class extends Controller {
  static values = {
    data: Object
  }

  connect() {
    const stateCounts = this.dataValue
    if (!stateCounts || Object.keys(stateCounts).length === 0) {
      console.warn("No data for map.")
      return
    }

    const data = [{
      type: "choropleth",
      locationmode: "USA-states",
      locations: Object.keys(stateCounts), // ["CA", "TX", ...]
      z: Object.values(stateCounts),       // [8, 59, ...]
      colorscale: "Blues",
      reversescale: true,
      colorbar: { title: "Educators" }
    }]

    const layout = {
      title: "Educators by State",
      geo: {
        scope: "usa",
        showlakes: true,
        lakecolor: "rgb(255,255,255)"
      }
    }

    Plotly.newPlot(this.element, data, layout, { responsive: true })
  }
}

