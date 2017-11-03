\name{QPFSLASSO}
\alias{QPFSLASSO}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Titulo
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
QPFSLASSO(x, lab, cont, class = NULL, lengths = NULL, threshold = NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x}{
%%     ~~Describe \code{x} here~~
}
  \item{lab}{
%%     ~~Describe \code{lab} here~~
}
  \item{cont}{
%%     ~~Describe \code{cont} here~~
}
  \item{class}{
%%     ~~Describe \code{class} here~~
}
  \item{lengths}{
%%     ~~Describe \code{lengths} here~~
}
  \item{threshold}{
%%     ~~Describe \code{threshold} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (x, lab, cont, class = NULL, lengths = NULL, threshold = NULL) 
{
    print("Normalizing...")
    genes <- names(x)[1:(ncol(x) - 2)]
    if (!is.null(lengths)) 
        x[1:nrow(x), 1:(ncol(x) - 2)] <- t(rpkm(t(x[1:nrow(x), 
            1:(ncol(x) - 2)]), lengths[as.character(genes)]))
    x <- data.table(x)
    genes_int <- paste("G", seq(1:length(genes)), sep = "_")
    names(x)[1:(ncol(x) - 2)] <- genes_int
    temp <- quote(lab)
    condition <- x[, ..lab]$a
    names(x)[which(names(x) == lab)] <- "condition"
    temp <- quote(cont)
    control <- x[, ..cont]$a
    names(x)[which(names(x) == cont)] <- "control"
    print("Calculating medians...")
    summary <- .getSummary(x)
    print("Obtaining the alpha...")
    alpha <- .getAlpha(summary, condition, genes_int)
    print("Calculating weights...")
    no_cores <- detectCores() - 1
    cl <- makeCluster(no_cores)
    a <- pbsapply(genes_int, FUN = .obtein_weight, ruta = ruta, 
        alpha = alpha, cl = cl)
    stopCluster(cl)
    "Reading weights"
    pesos <- c()
    for (gen in genes_int) {
        pesos <- c(pesos, scan(paste0(ruta, "auxiliares/", gen), 
            quiet = T))
    }
    names(pesos) <- paste(rep(genes, each = length(unique(condition))), 
        rep(unique(condition), length(genes)), sep = "_")
    if (!is.null(threshold)) {
        pesos <- pesos[pesos > threshold]
    }
    return(.sort_conditions(pesos))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
