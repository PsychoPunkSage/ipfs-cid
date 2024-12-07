# Makefile for IPFS CID Tool

# Variables
BINARY_NAME = ipfs_cid_tool
CARGO = cargo
BUILD_MODE = release
TARGET_DIR = target/$(BUILD_MODE)
BINARY = $(TARGET_DIR)/$(BINARY_NAME)
LOG_DIR = logs
TEST_DIR = test_files

# Colors for pretty output
GREEN = \033[0;32m
YELLOW = \033[1;33m
NC = \033[0m # No Color

.PHONY: all clean build test setup demo generate compare validate run-all

# Create necessary directories
setup:
	@echo "$(GREEN)Setting up directories...$(NC)"
	@mkdir -p $(LOG_DIR)
	@mkdir -p $(TEST_DIR)
	@echo "Hello IPFS!" > $(TEST_DIR)/test1.txt
	@echo "Hello IPFS!" > $(TEST_DIR)/test2.txt
	@echo "Different content" > $(TEST_DIR)/test3.txt
	@echo "$(GREEN)Setup complete!$(NC)"

# Build the project
build:
	@echo "$(GREEN)Building $(BINARY_NAME)...$(NC)"
	@$(CARGO) build --$(BUILD_MODE)
	@echo "$(GREEN)Build complete!$(NC)"

# Clean build artifacts and logs
clean:
	@echo "$(YELLOW)Cleaning up...$(NC)"
	@$(CARGO) clean
	@rm -rf $(LOG_DIR)/*
	@rm -rf $(TEST_DIR)/*
	@echo "$(GREEN)Clean complete!$(NC)"

# Run tests
test: build
	@echo "$(GREEN)Running tests...$(NC)"
	@$(CARGO) test 2>&1 | tee $(LOG_DIR)/test.log
	@echo "$(GREEN)Tests complete! Check $(LOG_DIR)/test.log for details$(NC)"

# Generate CID for a file
generate: build
	@echo "$(GREEN)Generating CID for test files...$(NC)"
	@echo "Test file 1:" | tee -a $(LOG_DIR)/generate.log
	@./$(BINARY) generate --file $(TEST_DIR)/test1.txt 2>&1 | tee -a $(LOG_DIR)/generate.log
	@echo "\nTest file 2:" | tee -a $(LOG_DIR)/generate.log
	@./$(BINARY) generate --file $(TEST_DIR)/test2.txt 2>&1 | tee -a $(LOG_DIR)/generate.log
	@echo "\nTest file 3:" | tee -a $(LOG_DIR)/generate.log
	@./$(BINARY) generate --file $(TEST_DIR)/test3.txt 2>&1 | tee -a $(LOG_DIR)/generate.log
	@echo "$(GREEN)Generation complete! Check $(LOG_DIR)/generate.log for details$(NC)"

# Compare two files
compare: build
	@echo "$(GREEN)Comparing files...$(NC)"
	@echo "Comparing identical files (test1.txt and test2.txt):" | tee $(LOG_DIR)/compare.log
	@./$(BINARY) compare --file1 $(TEST_DIR)/test1.txt --file2 $(TEST_DIR)/test2.txt 2>&1 | tee -a $(LOG_DIR)/compare.log
	@echo "\nComparing different files (test1.txt and test3.txt):" | tee -a $(LOG_DIR)/compare.log
	@./$(BINARY) compare --file1 $(TEST_DIR)/test1.txt --file2 $(TEST_DIR)/test3.txt 2>&1 | tee -a $(LOG_DIR)/compare.log
	@echo "$(GREEN)Comparison complete! Check $(LOG_DIR)/compare.log for details$(NC)"

# Validate a CID
validate: build
	@echo "$(GREEN)Validating CID...$(NC)"
	@CID=$$(./$(BINARY) generate --file $(TEST_DIR)/test1.txt | grep -o "Generated CID: .*" | cut -d' ' -f3) && \
	echo "Validating CID: $$CID" | tee $(LOG_DIR)/validate.log && \
	./$(BINARY) validate --cid $$CID 2>&1 | tee -a $(LOG_DIR)/validate.log
	@echo "$(GREEN)Validation complete! Check $(LOG_DIR)/validate.log for details$(NC)"

# Run all commands in sequence (for demo)
run-all: clean setup build generate compare validate
	@echo "$(GREEN)Full demo completed!$(NC)"
	@echo "$(GREEN)Check the $(LOG_DIR) directory for all logs:$(NC)"
	@echo "  - $(LOG_DIR)/generate.log"
	@echo "  - $(LOG_DIR)/compare.log"
	@echo "  - $(LOG_DIR)/validate.log"

# Default target
all: run-all