# Makefile for Go CLI Application

# Application settings
APP_NAME := tfmcalls
SRC_DIR := ./cmd/$(APP_NAME)
BIN_DIR := ./bin
VERSION := $(shell git describe --tags --always --dirty)

# Go settings
GO := go
GO_FLAGS := -ldflags="-X main.Version=$(VERSION)"

# Default target
.PHONY: all
all: build

# Build the application
.PHONY: build
build:
	@echo "Building $(APP_NAME)..."
	$(GO) build $(GO_FLAGS) -o $(BIN_DIR)/$(APP_NAME) $(SRC_DIR)

# Run tests
.PHONY: test
test:
	@echo "Running tests..."
	$(GO) test ./...

# Run the application
.PHONY: run
run:
	@echo "Running $(APP_NAME)..."
	$(BIN_DIR)/$(APP_NAME)

# Clean up build artifacts
.PHONY: clean
clean:
	@echo "Cleaning up..."
	rm -rf $(BIN_DIR)

# Update dependencies
.PHONY: deps
deps:
	@echo "Updating dependencies..."
	$(GO) mod tidy

# Format code
.PHONY: fmt
fmt:
	@echo "Formatting code..."
	$(GO) fmt ./...

# Lint code
.PHONY: lint
lint:
	@echo "Linting code..."
	$(GO) vet ./...

# Display help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all       Build the application (default)"
	@echo "  build     Compile the application"
	@echo "  test      Run tests"
	@echo "  run       Run the compiled application"
	@echo "  clean     Remove build artifacts"
	@echo "  deps      Update dependencies"
	@echo "  fmt       Format code"
	@echo "  lint      Lint code"
	@echo "  help      Display this help message"
