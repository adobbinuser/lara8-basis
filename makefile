docker_name = my-app-php-fpm
docker_image = testmynew_php-fpm

help: #prints list of commands
	@cat ./makefile | grep : | grep -v "grep"

start: #start docker container #
	@docker-compose -f ./docker/docker-compose-dev.yml up -d

stop: #stop docker container
	@docker-compose -f ./docker/docker-compose-dev.yml down

img_build: #install npm
	@docker-compose -f ./docker/docker-compose-dev.yml up -d --build

remove: #remove docker image
	@docker-compose -f ./docker/docker-compose-dev.yml down;  docker rmi -f $(docker_image)

composer_update: #update vendors
	@docker exec -it $(docker_name) bash -c 'php composer.phar update  && php composer.phar dump-autoload'

composer_dump: #update vendors
	@docker exec -it $(docker_name) bash -c 'php composer.phar dump-autoload'

set_env: #set default environments
	@cp ./.env.example ./.env

install_mc: #install mc#
	@docker exec -it $(docker_name) bash -c 'apt-get update && apt-get install -y mc'

create_controller: #create controller name=[controllerName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:controller $(name) '

create_resource: #create controller name=[controllerName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:controller $(name) --resource '

create_model: #create model name=[modelName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:model "$(name)" -m '

create_seeder: #create seeder name=[seederName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:seeder $(name) '

create_test: #create test name=[testName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:test $(name)Test '

create_email: #create email name=[emailName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:mail $(name) '

create_middleware: #create middleware name=[emailName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:middleware $(name) '

create_command: #create console command name=[emailName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:command $(name) '

create_queue_job: #create queue job name=[emailName]
	@docker exec -it $(docker_name) bash -c 'php artisan make:job $(name) '

migration: #run migration
	@docker exec -it $(docker_name) bash -c 'php composer.phar dump-autoload && php artisan migrate'

seed: #run migration
	@docker exec -it $(docker_name) bash -c 'php composer.phar dump-autoload && php artisan db:seed'

refresh: #Refresh the database and run all database seeds
	@docker exec -it $(docker_name) bash -c 'php composer.phar dump-autoload && php artisan migrate:refresh --seed'

route: #show all routes
	@docker exec -it $(docker_name) bash -c 'php artisan route:list'

conf: #refresh config cache
	@docker exec -it $(docker_name) bash -c 'php artisan config:cache'

test: #run test cases
	@docker exec -it $(docker_name) bash -c 'php artisan config:clear && vendor/bin/phpunit'

test_class: #test specific class name="$(name)"
	@docker exec -it $(docker_name) bash -c 'vendor/bin/phpunit --filter $(name)'

clear_cache: #clear laravel cache php artisan optimize --force php artisan config:cache php artisan route:cache
	@docker exec -it $(docker_name) bash -c 'php artisan cache:clear && php artisan view:clear && php artisan route:clear && php artisan config:clear'

socket: #start socket message service
	@docker exec -it $(docker_name) bash -c 'php artisan socket_messages_server:serve'

remove_tmp_files: #remove files from tmp folder
	@docker exec -it $(docker_name) bash -c 'php artisan tmp_files:remove'

connect: #connect to container bash
	@docker exec -it $(docker_name) bash

connect_beanstalkd: #connect to container bash
	@docker exec -it beanstalkd bash

connect_mysql: #connect to container bash
	@docker exec -it mysql bash

version: #laravel version
	@docker exec -it $(docker_name) bash -c 'php artisan --version'

volumes: #docker volumes list
	@docker volume ls

rm_volume: #remove docker volume name=[volumeName]
	@docker-compose -f ./docker/docker-compose-dev.yml down &&  docker volume rm $(name)

cache_route: #cache route
	@docker exec -it $(docker_name) bash -c 'php artisan route:cache'

start_queue: #start queue worker
	@docker exec -it $(docker_name) bash -c 'php artisan queue:work'

prod: #optimizations for production server
	@docker exec -it $(docker_name) bash -c 'php artisan route:clear && php artisan route:cache && php artisan optimize'

swagger_publish: #publish swagger conf
	@docker exec -it $(docker_name) bash -c 'php artisan l5-swagger:publish'

swagger: #generate dock
	@docker exec -it $(docker_name) bash -c 'php artisan l5-swagger:generate'

populate_vendors: #generate dock
	@docker exec -it $(docker_name) bash -c 'cp -R ./vendor ./ven ' &&  sh -c 'rm -R ./vendor; mv ./ven ./vendor'

npm_install: #install npm
	@docker exec -it $(docker_name) bash -c 'npm install; npm rebuild node-sass'

build: #install npm
	@docker exec -it $(docker_name) bash -c 'npm run all-dev'

build_watch: #install npm
	@docker exec -it $(docker_name) bash -c 'npm run all-watch'

log_watch: #install npm
	@clear;  docker exec -it $(docker_name) bash -c 'echo "" > ./storage/logs/laravel.log; tail -f ./storage/logs/laravel.log'
