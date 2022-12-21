FROM rocker/r-bspm:20.04
RUN apt update -y && apt upgrade -y && apt install -y \
    libxml2-dev
RUN install.r languageserver httpgd plumber shiny rlog remotes testthat cpp11
##RUN installGithub.r analythium/rconfig