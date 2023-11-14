include ../common/commands.mk
.DEFAULT_GOAL := build

executables := \
	$(GO_TARGETS) \
	target/base64_go_gccgo

artifacts := $(executables)

all_runners := $(patsubst %,run[%], $(artifacts)) \
	run[test.js]

# Build

.PHONY: build
build: $(artifacts)

target/base64_go_gccgo: go/base64 $(GO_SOURCE) | gofmt
	$(GCC_GO_BUILD)

# Run

.PHONY: run
run: $(all_runners)

## Common recipe for all runners
.PHONY: $(all_runners)
$(all_runners)::
	$(ECHO_RUN)

## Runners
executable_runners := $(patsubst %,run[%], $(executables))
$(executable_runners):: run[%] : %
	$(EXECUTABLE_RUN)


run[test.js]:: run[%]: %
	$(NODE_RUN)

# Utilities

.PHONY: clean
clean: clean-go
	-rm -rf target
