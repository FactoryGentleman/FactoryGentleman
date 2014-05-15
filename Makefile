PODS := Pods
BUILD := build
WORKSPACE := FactoryGentleman.xcworkspace
SDK := iphonesimulator

default: test

ci: clean test

test:
	xctool test -scheme FactoryGentleman-Mac -workspace $(WORKSPACE) ONLY_ACTIVE_ARCH=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES OBJROOT=$(BUILD)
	xctool test -scheme FactoryGentleman-iOS -workspace $(WORKSPACE) -sdk $(SDK) ONLY_ACTIVE_ARCH=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES OBJROOT=$(BUILD)

coverage:
	coveralls -e Spec -e Pods

clean:
	rm -rf $(BUILD)
