FOSAFETY_URL <- "https://fortordsafety.com//cgi-bin/databasedump.rb"

#' @importFrom jsonlite fromJSON
#' @export
pull_data <- function(.url = NULL) {
  if (!is.null(.url)) {
    stopifnot(".url must be a character" = is.character(.url))
    return(jsonlite::fromJSON(.url))
  }
  jsonlite::fromJSON(FOSAFETY_URL)
}

#' @importFrom data.table setDT
#' @importFrom lubridate mdy_hms
#' @importFrom stringi stri_sub
#' @export
process_data <- function(.df, .complete = TRUE) {
  stopifnot(".df must be a `data.frame`"  = is.data.frame(.df))
  stopifnot(".complete must be `logical`" = is.logical(.complete))
  out <- data.table::setDT(.df)[starttime != "Incomplete"
                                ][ , date := lubridate::dmy(
                                  stringi::stri_sub(starttime, 5L, 24L))]
  if (.complete) {
    out <- out[complete == "true"]
  }
  out
}

#' @importFrom data.table is.data.table fifelse setDT setnames .N
#' @importFrom lubridate floor_date ceiling_date
#' @importFrom stringi stri_sub
#' @export
summarize_data <- function(.df, .by, .floor = TRUE, .groups = FALSE) {
  stopifnot(".df must be a `data.frame`"  = is.data.frame(.df))
  stopifnot(".by must be a charater"      = is.character(.by))
  stopifnot(".floor must be a logical"    = is.logical(.floor))
  # Coerce data.frame into data.table ------------------------------------------
  if (!data.table::is.data.table(.df)) data.table::setDT(.df)
  # Summarize magic ------------------------------------------------------------
  if(.groups) {
    if (.floor) {
      out <- .df[, c("group_id", "date") := .(
        paste0(session, "-", stringi::stri_sub(starttime, 5L, 24L)),
        lubridate::floor_date(date, unit = .by))]
    } else {
      out <- .df[, c("group_id", "date") := .(
        paste0(session, "-", stringi::stri_sub(starttime, 5L, 24L)),
        lubridate::floor_date(date, unit = .by))]
    }
    out <- out[, keyby = .(group_id, date), .(count = .N)
               ][, type := data.table::fifelse(count > 1, "Group", "Individual")
                 ][, type := paste0(type, " (", .N, ")"), by = .(type, date)
                   ][, keyby = .(date, type), .(count = sum(count))]

    data.table::setnames(out, old = c("count", "date"),
                         new = c(paste0("individuals_by_", .by),
                                 data.table::fifelse(.floor,
                                                     "floor_date",
                                                     "ceiling_date")))
  } else {
    if (.floor) {
      out <- .df[, by = .(floor_date = lubridate::floor_date(date,
                                                             unit = .by)),
                 .(count = .N)]
    } else {
      out <- .df[, by = .(ceiling_date = lubridate::ceiling_date(date,
                                                                 unit = .by)),
                 .(count = .N)]
    }
    data.table::setnames(out, old = "count",
                         new = paste0("individuals_by_", .by))
  }
  return(out)
}

# test <- fosafety::pull_data() |>
#   fosafety::process_data() |>
#   fosafety::summarize_data(.by = "year", .floor = TRUE, .groups = TRUE)
