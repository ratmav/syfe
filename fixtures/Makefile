# Example Makefile to demonstrate folding and syntax highlighting

# Variables
CC := gcc
CXX := g++
CFLAGS := -Wall -Wextra -pedantic -O2
CXXFLAGS := $(CFLAGS) -std=c++17
LDFLAGS := -L/usr/local/lib
INCLUDES := -I./include -I/usr/local/include
TARGET := example
BUILD_DIR := build
SRC_DIR := src
TEST_DIR := tests

# Source files
C_SOURCES := $(wildcard $(SRC_DIR)/*.c)
CXX_SOURCES := $(wildcard $(SRC_DIR)/*.cpp)
OBJECTS := $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SOURCES))
OBJECTS += $(patsubst $(SRC_DIR)/%.cpp,$(BUILD_DIR)/%.o,$(CXX_SOURCES))

# Phony targets
.PHONY: all clean test debug release install uninstall format check

# Default target
all: $(BUILD_DIR) $(TARGET)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Linking the final target
$(TARGET): $(OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "Build complete: $(TARGET)"

# Compile C source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) $(INCLUDES) -c -o $@ $<

# Compile C++ source files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c -o $@ $<

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) $(TARGET)
	@echo "Cleaned build artifacts"

# Run tests
test: all
	@echo "Running tests..."
	$(TEST_DIR)/run_tests.sh

# Debug build
debug: CFLAGS += -g -DDEBUG
debug: CXXFLAGS += -g -DDEBUG
debug: all

# Release build
release: CFLAGS += -O3 -DNDEBUG
release: CXXFLAGS += -O3 -DNDEBUG
release: all

# Install the application
install: all
	@echo "Installing $(TARGET) to /usr/local/bin"
	cp $(TARGET) /usr/local/bin/
	@echo "Installation complete"

# Uninstall the application
uninstall:
	@echo "Removing $(TARGET) from /usr/local/bin"
	rm -f /usr/local/bin/$(TARGET)
	@echo "Uninstallation complete"

# Format the source code
format:
	@echo "Formatting source code..."
	find $(SRC_DIR) $(TEST_DIR) -name "*.c" -o -name "*.h" -o -name "*.cpp" -o -name "*.hpp" | xargs clang-format -i
	@echo "Formatting complete"

# Static code analysis
check:
	@echo "Running static analysis..."
	cppcheck --enable=all $(SRC_DIR)
	@echo "Static analysis complete"

# Generate documentation
docs:
	@echo "Generating documentation..."
	doxygen Doxyfile
	@echo "Documentation complete"

# Dependency generation
deps:
	@echo "Generating dependencies..."
	$(CC) -MM $(CFLAGS) $(INCLUDES) $(C_SOURCES) > deps.mk
	$(CXX) -MM $(CXXFLAGS) $(INCLUDES) $(CXX_SOURCES) >> deps.mk
	@echo "Dependencies generated"

# Include generated dependencies if they exist
-include deps.mk

# Help target
help:
	@echo "Available targets:"
	@echo "  all      - Build the project (default)"
	@echo "  clean    - Remove build artifacts"
	@echo "  test     - Run tests"
	@echo "  debug    - Build with debug symbols"
	@echo "  release  - Build optimized release version"
	@echo "  install  - Install to /usr/local/bin"
	@echo "  uninstall - Remove from /usr/local/bin"
	@echo "  format   - Format source code"
	@echo "  check    - Run static analysis"
	@echo "  docs     - Generate documentation"
	@echo "  deps     - Generate dependencies"
	@echo "  help     - Show this help message"