Feature: Options processing
  In order to use the program conveniently
  As a user
  I want options to be parsed correctly

  Scenario: Displaying help when run with "-h"
    When I run `nrename -h`
    Then the exit status should be 0
    And the stdout should contain "Usage: nrename "

  Scenario: Displaying help when run without any options
    When I run `nrename`
    Then the exit status should be 0
    And the stdout should contain "Usage: nrename "

  Scenario: Displaying version
    When I run `nrename --version`
    Then the exit status should be 0
    And the stdout should match /^(\d+)\.(\d+)\.(\d+)$/

  Scenario: Passing valid directory name
    Given a directory named "foo_bar"
    When I run `nrename foo_bar`
    Then the exit status should be 0

  Scenario: Passing invalid directory name
    When I run `nrename no_dir`
    Then the exit status should be 1
    And the stderr should contain "no_dir is not a valid directory."

  Scenario: Passing regular file instead of directory
    Given an empty file named "foo"
    When I run `nrename foo`
    Then the exit status should be 1
    And the stderr should contain "foo is not a valid directory."
