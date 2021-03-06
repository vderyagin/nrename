Feature: Renaming files
  In order to get my files nicely sortable
  As a user
  I want program to rename files correctly

  Scenario: Renaming regular files in specified directory
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
    | 001.txt |
    | 010.txt |
    | 023.txt |
    | 101.txt |
    | 200.txt |

  Scenario: Renaming directories in specified directory
    Given a directory named "dir"
    And the following directories inside directory "dir":
    | 1    |
    | 10   |
    | 0023 |
    | 101  |
    | 200  |
    When I run `nrename -DX dir`
    Then the exit status should be 0
    And the following directories should exist inside directory "dir":
    | 001 |
    | 010 |
    | 023 |
    | 101 |
    | 200 |

  Scenario: Dry-run
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | 1.txt    |
    | 10.txt   |
    | 0023.txt |
    When I cd to "dir"
    When I run `nrename .`
    Then the exit status should be 0
    And the stderr should contain "No renaming is done. Run with -X option to perform actual changes."
    And the following files should exist:
    | 1.txt    |
    | 10.txt   |
    | 0023.txt |
    And the following files should not exist:
    | 01.txt |
    | 23.txt |

  Scenario: Renaming files in multiple directories
    Given a directory named "foo"
    And a directory named "bar"
    And the following empty files inside directory "foo":
    | 1.txt   |
    | 010.txt |
    And the following empty files inside directory "bar":
    | 33.txt    |
    | 01234.txt |
    And I run `nrename -X foo bar`
    Then the exit status should be 0
    And the following files should exist inside directory "foo":
    | 01.txt |
    | 10.txt |
    And the following files should exist inside directory "bar":
    | 0033.txt |
    | 1234.txt |

  Scenario: Renaming files recursively
    Given a directory named "foo"
    And a directory named "bar"
    And the following empty files inside directory "foo":
    | 1.txt   |
    | 010.txt |
    And the following empty files inside directory "bar":
    | 33.txt    |
    | 01234.txt |
    And I run `nrename -XR .`
    Then the exit status should be 0
    And the following files should exist inside directory "foo":
    | 01.txt |
    | 10.txt |
    And the following files should exist inside directory "bar":
    | 0033.txt |
    | 1234.txt |

  Scenario: Renaming files with bare numbers
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | bb1.txt    |
    | bb10.txt   |
    | cc0023.txt |
    When I run `nrename -XN dir`
    Then the exit status should be 0
    And the following files should exist inside directory "dir":
    | 01.txt |
    | 10.txt |
    | 23.txt |
    And the following files should not exist:
    | bb1.txt    |
    | bb10.txt   |
    | cc0023.txt |

  Scenario: Using custom regular expression
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | 003_1.txt    |
    | 003_10.txt   |
    | 003_0023.txt |
    When I cd to "dir"
    When I run `nrename -X --regexp '^003_(\d+)\.txt' .`
    Then the exit status should be 0
    And the following files should exist:
    | 003_01.txt |
    | 003_10.txt |
    | 003_23.txt |

  Scenario: Renaming files from scratch
    Given a directory named "dir"
    And the following empty files inside directory "dir":
    | 1.txt    |
    | 10.txt   |
    | 0023.txt |
    | 101.txt  |
    | 200.txt  |
    When I run `nrename -X --renumber dir`
    Then the exit status should be 0
    And the following files should exist inside directory "dir":
    | 1.txt |
    | 2.txt |
    | 3.txt |
    | 4.txt |
    | 5.txt |

  Scenario: Renaming files from scratch in right order
    Given a directory named "dir"
    And the following files with content inside directory "dir":
    | 1.txt    | first  |
    | 10.txt   | second |
    | 0023.txt | third  |
    | 101.txt  | fourth |
    | 200.txt  | fifth  |
    When I run `nrename -X --renumber dir`
    Then the exit status should be 0
    And the following files with content should exist inside directory "dir":
    | 1.txt | first  |
    | 2.txt | second |
    | 3.txt | third  |
    | 4.txt | fourth |
    | 5.txt | fifth  |
