# Offline trip map

The app bundles the 1:110 million Natural Earth land polygons, version 5.1.2 (about 134 KB), and draws saved routes in a local geographic projection with a latitude/longitude grid. No tile server, API key, internet connection, account or map download is used. Pinch and drag explore the map; routes break at pauses, missing reliable fixes and periods when precise route storage was disabled. Samples above the recorded limit use dashed segments and warning markers.

This is a coarse geographic basemap. It shows land and coastlines, not streets, addresses or navigation. Natural Earth is intended for small-scale world maps, so its coastlines are approximate and can differ from precise GPS points near the shore. The local equirectangular projection suits local trips; routes approaching the poles or spanning much of the globe are less representative. Saved GPS samples and exported GPX coordinates retain their original accuracy.

Source: [Natural Earth project repository, v5.1.2 land GeoJSON](https://github.com/nvkelso/natural-earth-vector/blob/v5.1.2/geojson/ne_110m_land.geojson).

License: [Natural Earth public-domain terms](https://www.naturalearthdata.com/about/terms-of-use/). The data is public domain and can be redistributed in the application. Natural Earth contributors include Tom Patterson, Nathaniel Vaughn Kelso and the wider project community. The on-screen attribution remains visible for clarity even though attribution is not a license requirement.

To update the asset, use an explicit version from that repository, verify the public-domain terms, replace `assets/maps/ne_110m_land.geojson`, and run the bundled map repository and route-geometry tests. The parser accepts finite longitude/latitude polygon coordinates only and performs decoding on an isolate.


## Optional local regional detail

Choose **Load regional map** in a recorded trip to select a `.geojson` or `.json`
document. Import is explicit and never downloads data or sends the route to a
server. Use a regional road/path dataset you have permission to use. A top-level
`attribution` string (1–240 characters) is required and displayed below the map.
The app does not verify ownership or the accuracy of imported data.

The file must be a GeoJSON FeatureCollection containing only LineString or
MultiLineString features. Coordinates use `[longitude, latitude]` decimal degrees;
all points must be finite and within geographic bounds. Lines require at least two
points. Limits: 5 MiB UTF-8, 2,000 features and 50,000 coordinates in total. Parsing
runs off the UI isolate. This supports line context, without street-name labels,
map tiles, routing, automatic speed limits or navigation.

Example (fictional source attribution and road):

```json
{
  "type": "FeatureCollection",
  "attribution": "Example roads — your licensed source and required credit",
  "features": [{
    "type": "Feature",
    "properties": {},
    "geometry": {
      "type": "LineString",
      "coordinates": [[55.0, 25.0], [55.01, 25.01]]
    }
  }]
}
```

Each trip detail screen keeps its imported layer in memory until closed. It is
not copied to persistent app storage, backups or trip exports. Cancel selection
to keep an existing layer; Remove regional map clears it immediately. A failed
import shows a localized error and leaves the recorded trip unchanged. The source
file remains under the user's control.
