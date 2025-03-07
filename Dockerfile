# FROM jupyter/r-notebook:x86_64-ubuntu-22.04

# RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')"

# RUN Rscript -e "remotes::install_version('reticulate', version='1.25.0', repos='https://cloud.r-project.org')"
# RUN Rscript -e "remotes::install_version('ROSE', version='0.0-4', repos='https://cloud.r-project.org')"
# RUN Rscript -e "remotes::install_version('patchwork', version='1.3.0', repos='https://cloud.r-project.org')"
# RUN Rscript -e "remotes::install_version('glmnet', version='4.1-8', repos='https://cloud.r-project.org')"
# RUN Rscript -e "remotes::install_version('vcd', version='1.4-13', repos='https://cloud.r-project.org')"

# RUN Rscript -e "reticulate::py_install('pandas', method = 'conda')"
# RUN Rscript -e "reticulate::py_install('ucimlrepo', method = 'conda')"

FROM --platform=linux/amd64 rocker/verse

RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')"

RUN Rscript -e "remotes::install_version('reticulate', version='1.25.0', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('ROSE', version='0.0-4', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('patchwork', version='1.3.0', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('glmnet', version='4.1-8', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('vcd', version='1.4-13', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('tidymodels', version='1.2.0', repos='https://cloud.r-project.org')"

RUN apt update
RUN apt install -y python3.12 python3-pip python3-venv

# To install python
COPY src/requirements.txt /requirements.txt

# Create and activate a virtual environment, then install packages
RUN python3 -m venv /venv && \
    . /venv/bin/activate && \
    /venv/bin/pip install --upgrade pip && \
    /venv/bin/pip install -r /requirements.txt

# Change permissions: rwx for owner, rw for group and r for others
RUN chmod -R 764 /venv

# Set RETICULATE_PYTHON so R and RStudio use the virtual environment's Python
ENV RETICULATE_PYTHON="/venv/bin/python"

# Ensure the system uses the virtual environment's Python
ENV PATH="/venv/bin:$PATH"

# Set working directory
WORKDIR /home/rstudio