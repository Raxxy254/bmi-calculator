# 1. Use the official R-Shiny base image
FROM rocker/shiny:4.3.1

# 2. Install system dependencies required for R packages
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libxml2-dev \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# 3. Install the exact R packages your BMI app requires (including markdown support)
RUN R -e "install.packages(c('shiny', 'shinythemes', 'markdown', 'rmarkdown'), repos='https://cloud.r-project.org')"

# 4. Clean out the default placeholder shiny-server folder
RUN rm -rf /srv/shiny-server/*

# 5. Copy all files from your RStudio project folder into the container
COPY . /srv/shiny-server/

# 6. Expose the port Shiny Server runs on
EXPOSE 3838

# 7. Instruct the container to start Shiny Server automatically
CMD ["/usr/bin/shiny-server"]
