
<!-- README.md is generated from README.Rmd. Please edit that file -->

# {suntimes}

<!-- badges: start -->
<!-- badges: end -->

## What is it?

{suntimes} is an `R` API wrapper for solar event times from
[sunrise-sunset.org](https://sunrise-sunset.org). The returned variables
are

- sunrise
- sunset
- solar noon
- day length
- civil twilight start
- civil twilight end
- nautical twilight start
- nautical twilight end
- astronomical twilight start
- astronomical twilight end

## Why was it made?

{suntimes} was made as a teaching aid to show students (i) how to
interface with simple APIs, and (ii) how to author packages.

In practice, it is better to compute solar event times internally in `R`
rather than rely on an external API. Two recommended packages are

- [{suncalc}](https://github.com/datastorm-open/suncalc)
- [{oce}](https://github.com/dankelley/oce/)

## Usage limits and attribution

[sunrise-sunset.org](https://sunrise-sunset.org) provide their API free
of charge on the understanding that you do not use the API in a manner
that exceeds reasonable request volume, constitutes excessive or abusive
usage.

Should you use the data provided by the API, you must show attribution
with a link to <https://sunrise-sunset.org>.

## Installation

Install the development version from [GitHub](https://github.com/) by
typing the following:

``` r
# Install devtools if needed
#install.packages("devtools")

# Install suntimes using devtools
devtools::install_github("afsarchowdhury/suntimes")
```

A [CRAN](https://cran.r-project.org/) version is unavailable at this
time.

## Example

To return solar event times, the latitude and longitude of the location
in question must be provided. These can be obtained from most mapping
platforms, such as [latlong.net](https://www.latlong.net/).
Alternatively, use
[{tidygeocoder}](https://github.com/jessecambon/tidygeocoder/) to get
these programmatically.

The latitude and longitude for Land’s End is 50.065471 and -5.714856,
respectively. Using these values with no given date, solar event times
for the current day is returned.

``` r
# Load suntimes
library(suntimes)

# Get times
suntimes(lat = 50.065471, lon = -5.714856)
```

If you supply a date, solar event times are returned for that date.
Note: date must be supplied as a string in YYYY-MM-DD format.

``` r
suntimes(lat = 50.065471, lon = -5.714856, date = "2023-08-31")
```

All times are returned in UTC. For summer time adjustments, you must
provide a timezone. Note: `R` must recognise the timezone on your
system. Use `OlsonNames()` for valid timezones.

``` r
suntimes(lat = 50.065471, lon = -5.714856, date = "2023-08-31", timezone = "Europe/London")
```

Solar event times for multiple dates can be obtained using the function
`suntimes_multiple()`. Be mindful of the fair usage policy when using
this function.

``` r
suntimes_multiple(
  lat = 50.065471,
  lon = -5.714856,
  dates = c("2023-08-31", "2023-09-01"),
  timezone = "Europe/London"
)
```

## License

{suntimes} is released on a [GPLv3
license](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Citation

``` r
citation("suntimes")
#> To cite suntimes in publications use:
#> 
#>   Chowdhury, A. (2023). suntimes: Sunrise and sunset times. version
#>   0.1.0. Hyde High School. Tameside, Greater Manchester.
#>   https://github.com/afsarchowdhury/suntimes
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {suntimes},
#>     author = {Afsar Chowdhury},
#>     year = {2023},
#>     url = {https://github.com/afsarchowdhury/suntimes},
#>   }
```
