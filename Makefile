PODS := Pods
BUILD := target

default: test

ci: clean test

test:
	xctool test -scheme FactoryGentleman-Mac -workspace FactoryGentleman.xcworkspace ONLY_ACTIVE_ARCH=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES OBJROOT=$(BUILD)
	xctool test -scheme FactoryGentleman-iOS -workspace FactoryGentleman.xcworkspace -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES OBJROOT=$(BUILD)

clean:
	rm -rf $(BUILD)
