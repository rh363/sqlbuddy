.PHONY: build clean test lint install release help

# Variables
BINARY_NAME=sqlbuddy
VERSION=$(shell git describe --tags --always --dirty)
BUILD_TIME=$(shell date -u '+%Y-%m-%d_%H:%M:%S')
LDFLAGS=-ldflags "-X github.com/rh363/sqlbuddy/internal/version.Version=${VERSION} -X github.com/rh363/sqlbuddy/internal/version.BuildTime=${BUILD_TIME}"
GOBIN=$(shell go env GOPATH)/bin

# Default target
.DEFAULT_GOAL := help

# Build the library
build: ## Build the package
	mkdir -p ./build
	go build ./... -o ./build


# Clean build artifacts
clean: ## Clean build artifacts
	rm -rf ./build
	rm -rf ./bin
	rm -rf ./dist
	rm -f coverage.txt

# Run tests
test: ## Run tests
	go test -v ./...

# Run tests with coverage
coverage: ## Run tests with coverage
	go test -v -coverprofile=coverage.txt -covermode=atomic ./...

show-coverage: coverage ## Run tests with coverage and open result in the browser
	go tool cover -html=coverage.txt

# Run linter
lint: deps ## Run linter
	$(GOBIN)/golangci-lint run ./...

# Install dependencies
deps: ## Install dependencies
	go mod download
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Install the library
install: ## Install the library
	go install ./...

# Build examples
examples: ## Build example applications
	go build -o ./build/examples ./examples/...

# Generate documentation
docs: ## Generate documentation
	go doc -all ./...

# Help target
help: ## Display this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'