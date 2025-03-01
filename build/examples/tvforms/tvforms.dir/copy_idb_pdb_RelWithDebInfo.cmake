# CMake generated file
# The compiler generated pdb file needs to be written to disk
# by mspdbsrv. The foreach retry loop is needed to make sure
# the pdb file is ready to be copied.

foreach(retry RANGE 1 30)
  if (EXISTS "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/hello.dir/${PDB_PREFIX}hello.pdb" AND (NOT EXISTS "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvforms/tvforms.dir/${PDB_PREFIX}hello.pdb" OR NOT "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvforms/tvforms.dir/${PDB_PREFIX}hello.pdb  " IS_NEWER_THAN "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/hello.dir/${PDB_PREFIX}hello.pdb"))
    execute_process(COMMAND ${CMAKE_COMMAND} -E copy "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/hello.dir/${PDB_PREFIX}hello.pdb" "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/tvforms/tvforms.dir/${PDB_PREFIX}" RESULT_VARIABLE result  ERROR_QUIET)
    if (NOT result EQUAL 0)
      execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)
    else()
      break()
    endif()
  elseif(NOT EXISTS "C:/Users/miguel/source/repos/turbovision-2.2.1/build/examples/hello.dir/${PDB_PREFIX}hello.pdb")
    execute_process(COMMAND ${CMAKE_COMMAND} -E sleep 1)
  endif()
endforeach()
