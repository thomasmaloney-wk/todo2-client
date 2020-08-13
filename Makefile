#------------------------------------------------------------------
# DART
#------------------------------------------------------------------
build:
	pub get
	pub global run webdev build

clean:
	rm -fr .packages
	rm -fr .dart_tool
	rm -fr ./build

run:
	pub get
	webdev serve

#------------------------------------------------------------------
# DOCKER
#------------------------------------------------------------------
gen-docker:
	docker build --build-arg GIT_SSH_KEY \
	  -f Dockerfile \
	  -t todo2-client:latest-release .

# gen-docker:
# 	docker build \
# 	  -f Dockerfile \
# 	  -t todo2-client:latest-release .


run-docker:
	echo "starting todo2-client on port 8080"
	docker-compose -f docker-compose-local.yaml up --force-recreate -d
	open http://localhost:8080

stop-docker:
	docker-compose -f docker-compose-local.yaml down