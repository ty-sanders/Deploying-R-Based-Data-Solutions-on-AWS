# Bare Bones Dockerfile for deploying Shiny Server with custom Shiny App (4.3.1)
FROM rocker/shiny:4.3.1

#We stand on the shoulders of giants
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
org.opencontainers.image.vendor="Rocker Project" \
org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>" 

# Standard non-R software updates and installs
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:cran/poppler
RUN apt-get install -y libcurl4-openssl-dev libxml2-dev libssl-dev libpng-dev libsodium-dev

# Git
RUN apt-get install -y wget git tar

# System requirements for R packages
RUN apt-get install -y postgresql-server-dev-all libmagick++-dev libpoppler-cpp-dev
RUN apt-get install -y libxkbcommon0 fonts-liberation libgbm1 pandoc libudunits2-dev libgdal-dev

# Limit file system bloat from installs
ENV _R_SHLIB_STRIP_=true

# R Packages 
RUN install2.r --error --skipinstalled \
    tidyverse \
    shiny \
    janitor \
    reactable \
    bslib \
    bsicons \
    htmlwidgets \
    shinyWidgets \
    shinydashboard \
    arrow \
    slackr \
    aws.s3 \
    jsonlite \
    config \
    shinyauthr \
    sodium \
    shinyjs \
    brio \
    desc \
    decor

# Add in Shiny App.R file (or set of files)
ADD ./app/* /srv/shiny-server/

# Add R console logs to application logs for debugging
ENV SHINY_LOG_STDERR=1

# Specify/create shiny user with appropriate permissions
USER shiny

# Open standard Shiny Server Port for controlled access
EXPOSE 3838

# Tell Container to run your app
CMD ["/usr/bin/shiny-server"]