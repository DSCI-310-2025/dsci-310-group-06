# This file is part of the standard setup for testthat.
# It is recommended that you do not modify it.
#
# Where should you do additional test configuration?
# Learn more about the roles of various files in:
# * https://r-pkgs.org/testing-design.html#sec-tests-files-overview
# * https://testthat.r-lib.org/articles/special-files.html

# Notes:
# library() + test_check() is package-specific. Milestone 3 hasn't made the function a package yet, so using source() + test_dir() instead.

library(testthat)
testthat::test_dir("work/tests/testthat/")  
  

