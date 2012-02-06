Feature: Renaming files
  In order to get my files nicely sortable
  As a user
  I want program to rename files correctly

  Scenario: Renaming files in specified directory
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | 1.txt    |
    | 10.txt   |
    | 0023.txt |
    | 101.txt  |
    | 200.txt  |
    When I run `nrename -X dir`
    Then the exit status should be 0
    And the following files should exist inside directory "dir":
    | 001.txt  |
    | 010.txt  |
    | 023.txt  |
    | 101.txt  |
    | 200.txt  |

  Scenario: Renaming files in current directory
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | 1.txt    |
    | 10.txt   |
    When I cd to "dir"
    And I run `nrename -X`
    Then the exit status should be 0
    And the following files should exist:
    | 01.txt   |
    | 10.txt   |

  Scenario: Dry-run
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | 1.txt    |
    | 10.txt   |
    | 0023.txt |
    When I cd to "dir"
    When I run `nrename`
    Then the exit status should be 0
    And the following files should exist:
    | 1.txt    |
    | 10.txt   |
    | 0023.txt |
    And the following files should not exist:
    | 01.txt   |
    | 23.txt   |

  Scenario: Renaming files in multiple directories
    Given a directory named "foo"
    And a directory named "bar"
    And the following empty files inside directory "foo":
    | 1.txt    |
    | 010.txt  |
    And the following empty files inside directory "bar":
    | 33.txt    |
    | 01234.txt |
    And I run `nrename -X foo bar`
    Then the exit status should be 0
    And the following files should exist inside directory "foo":
    | 01.txt   |
    | 10.txt   |
    And the following files should exist inside directory "bar":
    | 0033.txt |
    | 1234.txt |

  Scenario: Renaming files recursively
    Given a directory named "foo"
    And a directory named "bar"
    And the following empty files inside directory "foo":
    | 1.txt    |
    | 010.txt  |
    And the following empty files inside directory "bar":
    | 33.txt    |
    | 01234.txt |
    And I run `nrename -XR`
    Then the exit status should be 0
    And the following files should exist inside directory "foo":
    | 01.txt   |
    | 10.txt   |
    And the following files should exist inside directory "bar":
    | 0033.txt |
    | 1234.txt |
