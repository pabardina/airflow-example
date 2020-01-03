FROM puckel/docker-airflow

USER root

RUN set -xe \
  && pip install papermill flake8 \
	  'apache-airflow[kubernetes]' \
	  awscli \
	  sql_magic \
  && python3 -m ipykernel install

USER airflow

RUN mkdir -p ~/.aws
