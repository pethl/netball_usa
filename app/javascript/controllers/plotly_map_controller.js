import { Controller } from "@hotwired/stimulus"
import Plotly from "plotly.js-dist-min"

export default class extends Controller {
  static values = {
    data: Object,
    title: {
      type: String,
      default: "People by Location"
    },
    label: {
      type: String,
      default: "People"
    },
    mode: {
      type: String,
      default: "usa"
    }
  }

  connect() {
    const locationCounts = this.dataValue

    if (!locationCounts || Object.keys(locationCounts).length === 0) {
      console.warn("No data for map.")
      return
    }

    const locations = Object.keys(locationCounts)

    const containsCountryNames = locations.some(
      location => location.length > 2
    )

    const worldMap =
      this.modeValue === "world" ||
      containsCountryNames

    const hoverLabel = this.labelValue.toLowerCase()

    const maximumCount = Math.max(
      ...Object.values(locationCounts)
    )

    const tickInterval = worldMap ? 10 : 1

    const wholeNumberTicks = Array.from(
      {
        length:
          Math.floor(maximumCount / tickInterval) + 1
      },
      (_, index) => index * tickInterval
    )

    const allUsStateCodes = [
      "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE",
      "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS",
      "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS",
      "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY",
      "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
      "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV",
      "WI", "WY", "DC"
    ]

    const usaBackgroundTrace = {
      type: "choropleth",
      locationmode: "USA-states",
      locations: allUsStateCodes,
      z: allUsStateCodes.map(() => 0),

      zmin: 0,
      zmax: 1,

      colorscale: [
        [0, "rgb(226, 232, 240)"],
        [1, "rgb(226, 232, 240)"]
      ],

      showscale: false,
      hoverinfo: "skip",

      marker: {
        line: {
          color: "rgb(100, 116, 139)",
          width: 0.8
        }
      }
    }

    const peopleTrace = {
      type: "choropleth",

      locationmode: worldMap
        ? "country names"
        : "USA-states",

      locations: locations,
      z: Object.values(locationCounts),

      colorscale: "Blues",
      reversescale: true,

      marker: {
        line: {
          color: worldMap
            ? "rgb(203, 213, 225)"
            : "rgb(100, 116, 139)",

          width: worldMap
            ? 0.5
            : 0.8
        }
      },

      hovertemplate:
        `%{location}: %{z} ${hoverLabel}<extra></extra>`,

      colorbar: {
        title: this.labelValue,
        tickmode: "array",
        tickvals: wholeNumberTicks,
        ticktext: wholeNumberTicks.map(String)
      }
    }

    const data = worldMap
      ? [peopleTrace]
      : [usaBackgroundTrace, peopleTrace]

    const usaGeo = {
      scope: "usa",

      projection: {
        type: "albers usa"
      },

      resolution: 50,

      showland: true,
      landcolor: "rgb(226, 232, 240)",

      showlakes: true,
      lakecolor: "rgb(219, 234, 254)",

      showsubunits: true,
      subunitcolor: "rgb(100, 116, 139)",
      subunitwidth: 0.8,

      bgcolor: "rgba(0, 0, 0, 0)"
    }

    const worldGeo = {
      scope: "world",

      projection: {
        type: "natural earth"
      },

      showland: true,
      landcolor: "rgb(248, 250, 252)",

      showcountries: true,
      countrycolor: "rgb(255, 255, 255)",
      countrywidth: 1,

      showcoastlines: true,
      coastlinecolor: "rgb(203, 213, 225)",

      showocean: true,
      oceancolor: "rgb(239, 246, 255)",

      showlakes: true,
      lakecolor: "rgb(219, 234, 254)",

      bgcolor: "rgba(0, 0, 0, 0)"
    }

    const layout = {
      title: this.titleValue,

      geo: worldMap
        ? worldGeo
        : usaGeo,

      margin: {
        top: 60,
        right: 20,
        bottom: 20,
        left: 20
      },

      paper_bgcolor: "rgba(0, 0, 0, 0)"
    }

    Plotly.newPlot(
      this.element,
      data,
      layout,
      {
        responsive: true
      }
    )
  }
}