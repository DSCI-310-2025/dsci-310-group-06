FROM rocker/verse:4

RUN Rscript -e "install.packages('remotes', repos='https://cloud.r-project.org')"

RUN Rscript -e "remotes::install_version('ROSE', version='0.0-4', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('patchwork', version='1.3.0', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('glmnet', version='4.1-8', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('vcd', version='1.4-13', repos='https://cloud.r-project.org')"
RUN Rscript -e "remotes::install_version('tidymodels', version='1.2.0', repos='https://cloud.r-project.org')"

RUN apt update
RUN apt install -y python3.12 python3-pip python3-venv
COPY src/requirements.txt /requirements.txt

RUN python3.12 -m venv /venv
RUN /venv/bin/pip install -r /requirements.txt
