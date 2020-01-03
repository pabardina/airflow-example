.airflow-secret:
	@sleep 10
	@sops -d settings/local/secret.yaml > settings/local/.airflow-secret.yaml
	@docker-compose exec webserver bash -c "python3 settings/import-secret.py"
	@rm -f settings/local/.airflow-secret.yaml
	@touch $@

apply-secret:
	@sops -d settings/local/secret.yaml > settings/local/.airflow-secret.yaml
	@docker-compose exec webserver bash -c "python3 settings/import-secret.py"
	@rm -f settings/local/.airflow-secret.yaml

edit-secret:
	@sops settings/local/secret.yaml


up: 
	$(info Make: Starting containers.)
	@docker-compose up --build -d

start: up .airflow-secret

stop:
	$(info Make: Stopping environment containers.)
	@docker-compose stop

restart: stop start

bash:
	$(info Make: Bash in webserver container)
	@docker-compose exec webserver bash

logs:
	@docker-compose logs -f

test:
	$(info Make: Unit test dags files)
	@docker-compose exec webserver flake8 --max-line-length 120 --max-complexity 12 --statistics .


clean:
	@docker-compose down -v
	@rm -f .airflow-secret
	@rm -f settings/.airflow-secret.yaml
