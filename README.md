Comissioned for the New Museum’s *First Look* series, the code here stands as the front-end for the project and is used in conjunction with [github.com/dzucconi/multiple](https://github.com/dzucconi/multiple).

A web scraper used to fetch data from the New Museum's archive lives in [/archiver](/archiver)

`rake spec` runs the specs  
`rake archive:export` regenerates the JSON from the cached, scraped data  
`rake archive:refresh` re-fetches the data from the New Museum archive and regenerates the JSON
