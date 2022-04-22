Feature: PCMT Responsive

  Scenario: PCMT up and running
    Given that PCMT is set up
    Then PCMT should respond to an authenticated API request
