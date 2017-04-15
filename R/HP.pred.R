#' @title
#' Prediction of Heligman-Pollard model.
#'
#' @description
#' Predicts Heligman-Pollard model from Heligman-Pollard's parameters.
#'
#' @param life A life table created with \link{life.tab} or a dataframe with a vector of ages in the first column.
#' @param HPout A model object created with \link{HP.mod} with the Heligman-Pollard estimated params.
#' @param age A vector containing the ages at which each age interval begins. See Details
#' @param rm The number of age classes that want to be removed from optimization.
#'
#' @details
#' Mx is returned only if number of ages required for prediction is equal to the number of ages in the life table.
#'
#' @return
#' A dataframe with seven columns:
#' \item{age}{Age at the beginning of the interval.}
#' \item{Mx}{Number of observed deaths at age x.}
#' \item{qx.tot}{Total probability of death between ages x and x + n.}
#' \item{qx.nat}{Natural probability of death between ages x and x + n.}
#' \item{qx.young}{Young probability of death between ages x and x + n.}
#' \item{qx.risk}{Probability of death due to an externl risk between ages x and x + n.}
#' \item{qx.adult}{Adult or senescent probability of death between ages x and x + n.}
#'
#' @references
#' Heligman, L. and Pollard, J.H. (1980). The Age Pattern of Mortality. Journal of the Institute of Actuaries 107:49–80.
#'
#' Sharrow, D.J., Clark, S.J., Collinson, M.A., Kahn, K. and Tollman, S.M. (2013). The Age Pattern of Increases in Mortality Affected by HIV: Bayesian Fit of the Heligman-Pollard Model to Data from the Agincourt HDSS Field Site in Rural Northeast South Africa. Demogr. Res. 29, 1039–1096.
#'
#' @seealso \link{HP.mod}
#'
#' @keywords Heligman-Pollard mortality prediction
#'
#' @export

HP.pred <- function(life, HPout, age = seq(0,29,0.1), rm = 0){
        A <- HPout$out[1,2]
        B <- HPout$out[2,2]
        C <- HPout$out[3,2]
        D2 <- HPout$out[4,2]
        D <- HPout$out[5,2]
        E <- HPout$out[6,2]
        F <- HPout$out[7,2]
        G <- HPout$out[8,2]
        H <- HPout$out[9,2]
        age <- age
        Myoung <- A^(((age) + B)^C)
        Mrisk <- D2 + D * exp(-E * (log(age) - log(F))^2)
        Madult <- (G * (H^(age))) / (1 + G * (H^(age)))
        Mtot <- Myoung + Mrisk + Madult
        Mnat <- Myoung + Madult
        if (length(age) == length(life$Mx)){
                Mx <- life$Mx
                if(!rm == 0){
                        Mx[1:rm] <- NA
                }
                dataHP <- data.frame(age = age, Mx = Mx, qx.tot = Mtot, qx.nat = Mnat,
                                     qx.young = Myoung, qx.risk = Mrisk, qx.adult = Madult)
        } else {
                dataHP <- data.frame(age = age, qx.tot = Mtot, qx.nat = Mnat,
                                     qx.young = Myoung, qx.risk = Mrisk, qx.adult = Madult)
        }
        return(dataHP)
}
