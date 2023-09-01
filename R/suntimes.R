# API documentation ---------------------------
#https://sunrise-sunset.org/api

# Functions ---------------------------
## Sunrise and sunset times provided by sunrise-sunset.org
#' Get solar event times for single date.
#'
#' Returns times for sunrise, sunset, and various other solar events for the
#' chosen location, date, and timezone.
#' @param lat latitude in decimal degrees. Required.
#' @param lon longitude in decimal degrees. Required.
#' @param date date as string in YYYY-MM-DD format. If not present,
#' date defaults to current date. Optional.
#' @param timezone a character string containing a timezone to convert to.
#' R must recognise the name contained in the string as a time zone on your
#' system. Use OlsonNames() for valid timezones. If not present,
#' UTC is returned. Optional.
#' @examples
#' suntimes(50.065471, -5.714856)
#' suntimes(50.065471, -5.714856, "2023-08-31")
#' suntimes(50.065471, -5.714856, "2023-08-31", "Europe/London")
#' @export
suntimes <- function(lat, lon, date = NULL, timezone = NULL) {
  ## Path
  path <- "https://api.sunrise-sunset.org/json"

  ## Query
  result <- httr::GET(url = paste0(
    path,
    "?lat=", lat,
    "&lng=", lon,
    "&date=", date,
    "&formatted=0"
  ))

  ## Parse returned data as text
  response <- httr::content(result, as = "text", encoding = "UTF-8")

  ## Parse JSON and convert to dataframe
  df <- response |> jsonlite::fromJSON(flatten = TRUE)
  df <- df[1] |> data.frame()

  ## Convert to datetime
  df <- df |>
    dplyr::mutate(dplyr::across(.cols = dplyr::everything(),
                                .fns = lubridate::as_datetime))

  ## Convert to stipulated timezone
  if (is.null(timezone)) {
    df <- df
  } else {
    df <- df |>
      dplyr::mutate(
        dplyr::across(.cols = dplyr::everything(),
                      .fns = ~lubridate::with_tz(., tzone = timezone))
      )
  }

  ## Return
  return(df)
}

## Sunrise and sunset times provided by sunrise-sunset.org
#' Get solar event times for multiple dates.
#'
#' Returns times for sunrise, sunset, and various other solar events for the
#' chosen location, dates, and timezone.
#' @param lat latitude in decimal degrees. Required.
#' @param lon longitude in decimal degrees. Required.
#' @param dates dates as vector string in YYYY-MM-DD format. If not present,
#' date defaults to current date. Optional.
#' @param timezone a character string containing a timezone to convert to.
#' R must recognise the name contained in the string as a timezone on your
#' system. Use OlsonNames() for valid timezones. If not present,
#' UTC is returned. Optional.
#' @examples
#' suntimes_multiple(50.065471, -5.714856, c("2023-08-31", "2023-09-01"))
#' suntimes_multiple(50.065471, -5.714856, c("2023-08-31", "2023-09-01"), "Europe/London")
#' @export
suntimes_multiple <- function(lat, lon, dates = NULL, timezone = NULL) {
  df <- lapply(dates, function(i) suntimes::suntimes(lat, lon, date = i, timezone = timezone))
  df <- df |> dplyr::bind_rows()

  ## Return
  return(df)
}
