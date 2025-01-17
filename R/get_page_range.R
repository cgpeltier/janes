#' @title get_page_range
#' @description Pulls Janes page ranges for all data endpoints. Helper function
#'
#' @param country Country filter for news
#' @param branch Military branch
#' @param type Depends on endpoint
#' @param endpoint One of 6 options currently
#' @param query Search term
#' @param environment Of search, i.e. "Air"
#' @param operator_force Operator force
#' @param market Markets Forecast market
#' @param event_type Event type - JTIC or Intel Event
#' @param end_user_country JMF end user country
#' @param query Query
#' @param post_date Event post date
#' @param start_date Event start date
#' @param overall_family Overall equipment family
#'
#' @return Janes page ranges for a given search.
#' @importFrom httr GET
#' @importFrom httr add_headers
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_replace_all
#' @importFrom magrittr "%>%"


get_page_range <- function(country = NULL, branch = NULL, type = NULL,
                           operator_force = NULL, query = NULL, environment = NULL,
                           post_date = NULL, start_date = NULL, event_type = NULL,
                           market = NULL, end_user_country = NULL,
                           overall_family = NULL,
                           endpoint = c("inventories", "equipment", "orbats", "news",
                                        "bases", "airports", "countryrisks",
                                        "companies", "events", "equipmentrelationships",
                                        "references", "samsites", "ewsites",
                                        "satelliteImages", "marketforecasts",
                                        "nuclearsites")){



    if(endpoint %in% c("references", "news")){
        endpoint2 <- endpoint
    }else{
        endpoint2 <- paste0("data/", endpoint) }



    countries <- paste0(country, collapse = ")%3Cor%3Ecountryiso(")

    response <- httr::GET(url = paste0("https://developer.janes.com/api/v1/",
                                       endpoint2,"?q=",
                                       query,
                                       "&f=countryiso(",
                                       countries,
                                       ")%3Cand%3Emarket(",
                                       str_replace_all(market, " ", "%20"),
                                       ")%3Cand%3EENDUSERCOUNTRY(",
                                       str_replace_all(end_user_country," ", "%20"),
                                       ")%3Cand%3ESOURCE_TYPE(",
                                        str_replace_all(event_type, " ", "%20"),
                                       ")%3Cand%3EPOST_DATE(",
                                       str_replace_all(post_date, "::", "%3A%3A"),
                                       ")%3Cand%3Estart_Date(",
                                       str_replace_all(start_date, "::", "%3A%3A"),
                                       ")%3cand%3Ebranch(",
                                       stringr::str_replace_all(branch, " ", "%20"),
                                       ")%3Cand%3EoperatorForce(",
                                       stringr::str_replace_all(operator_force, " ", "%20"),
                                       ")%3cand%3Etype(",
                                       type,
                                       ")%3Cand%3Eoverallfamily(",
                                       overall_family,
                                       ")%3Cand%3Eenvironment(",
                                       environment,
                                       ")&num=1000"),
                          httr::add_headers(Authorization = Sys.getenv("JANES_KEY"))) %>%
        httr::content()

    range_temp <- ceiling(response[["metadata"]][["recordCount"]] / 1000)

    seq(1:range_temp)

}


#' @export
