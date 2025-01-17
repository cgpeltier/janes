#' @title get_janes_companies
#' @description Pulls Janes company data
#'
#' @param country Country in which base is located
#' @param query Search term for companies (i.e. company name)
#'
#' @return Janes equipment data.
#' @importFrom httr GET
#' @importFrom httr content
#' @importFrom jsonlite fromJSON
#' @importFrom stringr str_replace_all
#' @importFrom magrittr "%>%"
#' @importFrom stringr str_remove
#' @importFrom purrr map
#' @importFrom jsonlite flatten
#' @importFrom dplyr bind_rows
#' @importFrom dplyr rename
#' @importFrom tibble tibble
#' @importFrom tidyr unnest_wider
#' @importFrom tidyr unnest_auto
#' @importFrom dplyr select
#' @importFrom dplyr rename_with
#' @importFrom janitor clean_names
#' @importFrom janitor remove_empty
#' @importFrom dplyr starts_with
#' @importFrom dplyr any_of
#' @importFrom tidyr unite
#' @importFrom dplyr mutate
#' @export



get_janes_companies <- function(country = NULL, query = NULL){
    page_range <- get_page_range(country = country, endpoint = "companies",
                                 query = str_replace_all(query, " ", "%20"))
    companies <- map(page_range, ~ get_janes_info(x = .x, country = country,
                                               endpoint = "companies",
                                               query = str_replace_all(query, " ", "%20"))) %>%
        bind_rows()

    companies_data <- map(companies$url, get_janes_data)

    companies_data %>%
        tibble() %>%
        unnest_wider(".") %>%
        unnest_wider(".")  %>%
        conditional_unnest_wider("organisation") %>%
        unnest_all("organisation") %>%
        unnest_all("organisation") %>%
        unnest_all("organisation") %>%
        unnest_all("organisation") %>%
        rename_with(~ str_remove(., "^[^_]+_[^_]+_")) %>%
        rename_with(~ str_remove(., "(?<=[a-z])_(?=\\d+)"))
}


