# Macro that handles creation of libs
macro(create_lib lib lib_alias)
    add_library(${lib} STATIC)
    add_library(${lib_alias} ALIAS ${lib})
    target_include_directories(${lib}
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>/include
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    include_directories(
        ${CMAKE_SOURCE_DIR}/src
    )
    if(ENABLE_COVERAGE)
        target_link_libraries(${lib}
            gcov
        )
    endif()
    set_target_properties(${lib} PROPERTIES COMPILE_FLAGS "${CMAKE_CXX_FLAGS_DEBUG}")
endmacro(create_lib)
