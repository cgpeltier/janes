#' @title conditional_unnest_wider2
#' @description conditionally unnests_wider. Helper function.
#'
#' @param data Country filter for equipment
#' @param variable Query filter for equipment
#'
#' @return Unnests_wider if variable is in dataset, doesn't if not.
#' @importFrom tidyr unnest_wider
#'
#'


conditional_unnest_wider2 <- function(data, variable){

    if(variable %in% names(data)){

        return(unnest_wider(data, variable, names_sep = "_", names_repair = 'unique'))

    } else {

        return(data)

    }

  }


#' @export

