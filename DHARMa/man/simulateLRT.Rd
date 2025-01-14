% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulateLRT.R
\name{simulateLRT}
\alias{simulateLRT}
\title{Simulated Likelihood Ratio tests}
\usage{
simulateLRT(m0, m1, n = 250, seed = 123, plot = T,
  suppressWarnings = F, saveModels = F, ...)
}
\arguments{
\item{m0}{Null Model}

\item{m1}{Alternative Model}

\item{n}{number of simulations}

\item{seed}{random seed}

\item{plot}{whether null distribution should be plotted}

\item{suppressWarnings}{whether to suppress warnings that occur during refitting the models to simulated data}

\item{saveModels}{Whether to save refitted models}

\item{...}{additional parameters to pass on to the simulate function of the model object.}
}
\description{
This function uses the DHARMa model wrappers to generate simulated likelihood ratio tests (LRTs) based on a parameteric bootstrap.
}
\details{
The null hypothesis is that m0 is correct, the tests checks if the increase in likelihood of m1 is higher than expected, using data simulated from m0

The function performs a simulated LRT, which works as follows:
\enumerate{
\item H0: Model 1 is correct
\item Our test statistic is the log LRT of M1/M2. Empirical value will always be > 1 because in a nested setting, the more complex model cannot have a worse likelihood.
\item To generate an expected distribution of the test statistic under H0, we simulate new response data under M0, refit M0 and M1 on this data, and calculate the LRs.
\item Based on this, calculate p-values etc. in the usual way.
}

The motivation for using a simulated LRT rather than a standard ANOVA or AIC for model selection in mixed models is that df for mixed models are not clearly defined, thus standard ANOVA based on Chi2 statistics or AIC are unrealiable, in particular for models with large contributions of REs to the likelihood.

About warnings: it frequently occurs that models produce warnings when being refit to simulated data. This is not necessarily a sign of a problem, and may simply indicate that RE variance are fit to zero because the simulated data does not support such variances (as in the example), but it may also indicate that the models that are fit haven't converged. It is difficult to provide any general advice for these problems, other than checking whether refitted models seem to have reasonable parameter estimates. You can record the refitted models for inspection via the parameter saveModels, and suppress the warnings with surpressWarnings.
}
\note{
Note that the logic of an LRT assumes that m0 is nested in m1, which guarantees that the L(M1) > L(M0). The function does not explicitly check if models are nested and will work as long as data can be simulated from M0 that can be refit with M) and M1; however, I would strongly advice against using this for non-nested models unless you have a good statsitical reason for doing so.
}
\examples{

library(DHARMa)
library(lme4)

set.seed(123)
dat <- createData(sampleSize = 200, randomEffectVariance = 1)

m1 = glmer(observedResponse ~ Environment1 + (1|group), data = dat, family = "poisson")


m0 = glm(observedResponse ~ Environment1 , data = dat, family = "poisson")

\dontrun{
out = simulateLRT(m0, m1, n = 10)

# LRT produced warnings, can inspect what's going on
out = simulateLRT(m0, m1, saveModels = T, suppressWarnings = T, n = 10)
summary(out$saveModels[[2]]$refittedM1) # RE SD = 0
# Could try changing the optimizer to reduce warnings
}
}
\author{
Florian Hartig
}
