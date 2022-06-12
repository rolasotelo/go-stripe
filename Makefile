STRIPE_SECRET=sk_test_
STRIPE_KEY=pk_test_
GOSTRIPE_PORT=4000
API_PORT=4001
DSN=root@tcp(localhost:3306)/widgets?parseTime=true&tls=false

## build: builds all binaries
build: clean build_front build_back
	@printf "All binaries built 🕌 🕍 🛕!\n"

## clean: cleans all binaries and runs go clean
clean:
	@echo "Cleaning... 🧹"
	@- rm -f dist/*
	@go clean
	@echo "Cleaned ✨!"

## build_front: builds the front end
build_front:
	@echo "Building front end 🏗 🖥..."
	@go build -o dist/gostripe ./cmd/web
	@echo "Front end built 🏛 🖥!"

## build_back: builds the back end
build_back:
	@echo "Building back end 🏗 📺..."
	@go build -o dist/gostripe_api ./cmd/api
	@echo "Back end built 🏛 📺!"

## start: starts front and back end
start: start_front start_back

## start_front: starts the front end
start_front: build_front
	@echo "Starting the front end 🏁 🖥..."
	@env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe -port=${GOSTRIPE_PORT} -dsn="${DSN}" &
	@echo "Front end running 🏎 🖥!"

## start_back: starts the back end
start_back: build_back
	@echo "Starting the back end 🏁 📺..."
	@env STRIPE_KEY=${STRIPE_KEY} STRIPE_SECRET=${STRIPE_SECRET} ./dist/gostripe_api -port=${API_PORT} &
	@echo "Back end running 🏎 📺!"

## stop: stops the front and back end
stop: stop_front stop_back
	@echo "All applications stopped 🛑"

## stop_front: stops the front end
stop_front:
	@echo "Stopping the front end 🚦🖥..."
	@-pkill -SIGTERM -f "gostripe -port=${GOSTRIPE_PORT}"
	@echo "Stopped front end"

## stop_back: stops the back end
stop_back:
	@echo "Stopping the back end 🚦📺..."
	@-pkill -SIGTERM -f "gostripe_api -port=${API_PORT}"
	@echo "Stopped back end"

