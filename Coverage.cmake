# Code coverage target
set(COVERAGE_TARGET Coverage)
add_custom_target(
  ${COVERAGE_TARGET}
  COMMAND mkdir -p coverage
  COMMAND mkdir -p debug/coverage
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build
)

add_custom_command(
  TARGET ${COVERAGE_TARGET}
  # Generate gcov report
  COMMAND gcov -b ${CMAKE_SOURCE_DIR}/src/**/*.cpp ${CMAKE_SOURCE_DIR}/libs/**/*.cpp
  # create baseline coverage data file
  COMMAND lcov -c -i -q -d ../.. -o base_coverage.info
  # Make test executables and run tests
  COMMAND ${CMAKE_MAKE_PROGRAM} -C .. all
  COMMAND ${CMAKE_MAKE_PROGRAM} -C .. test
  # create test coverage data file
  COMMAND lcov -c -q -d ../.. -o coverage.info
  # Combine baseline and test coverage data
  COMMAND lcov -a base_coverage.info -a coverage.info -o coverage.info
  # Remove external libraries, main.cpp and test folder
  COMMAND lcov -r coverage.info '/usr/*' '*/external/*' '*/tests/*' '*main.cpp' -o coverage.info
  COMMAND genhtml coverage.info -o ../../coverage
  COMMAND echo "-- Coverage report saved to ${CMAKE_BINARY_DIR}/../coverage"
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build/debug/coverage
)
add_dependencies(${COVERAGE_TARGET} ${PROJECT_NAME})

# Make sure to clean up the coverage folder
set_property(
  DIRECTORY
  APPEND
  PROPERTY ADDITIONAL_MAKE_CLEAN_FILES coverage
)

# Reset code coverage target
add_custom_target(
  ClearCoverage
  COMMAND ${CMAKE_MAKE_PROGRAM} clean
  COMMAND rm -f ${OBJECT_DIR}/*.gcno
  COMMAND rm -f ${OBJECT_DIR}/*.gcda
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)
