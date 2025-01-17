Feature: Handle special buffers

  Scenario: Handle terminal buffer
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "terminal" RET
    Then Desktop session "terminal" should exist

    When I switch to directory "/tmp"
    And  I start an action chain
    And    I press "M-x"
    And    I type "term"
    And    I press "RET C-S-<backspace>"
    And    I type "/bin/cat"
    And    I execute the action chain
    And  I rename the buffer "*my-terminal*"

    Given I am in a fresh Emacs instance
    When I call M-x "desktop-load" RET "terminal" RET
    Then Buffer "*my-terminal*" should exist
    When I switch to buffer "*my-terminal*"
    Then Variable "default-directory" should be "/tmp/"
    And  Program "/bin/cat" should be running


  Scenario: Handle compilation buffer
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "compilation" RET
    Then Desktop session "compilation" should exist

    When I switch to directory "/tmp"
    And  I start an action chain
    And    I press "M-x"
    And    I type "compile"
    And    I press "RET C-S-<backspace>"
    And    I type "echo OK"
    And    I execute the action chain

    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-load" RET "compilation" RET
    Then Buffer "*compilation*" should exist
    When I switch to buffer "*compilation*"
    And  I press "g"
    Then I should see pattern "/tmp/"
    And  I should see pattern "^echo OK"


  Scenario: Handle indirect buffer
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "indirect-buffer" RET
    Then Desktop session "indirect-buffer" should exist

    And  I start an action chain
    And    I press "C-x C-f"
    And    I type "/tmp/foo"
    And    I execute the action chain
    And  I type "some content"
    And  I press "C-x C-s"
    And  I press "C-x 4 c"
    Then Buffer "foo" should exist
    And  Buffer "foo<2>" should exist

    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-load" RET "indirect-buffer" RET
    Then Buffer "foo" should exist
    And  Buffer "foo<2>" should exist
    When I switch to buffer "foo<2>"
    Then I should see pattern "some content"


  Scenario: Handle org agenda buffer
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "org-agenda-list" RET
    Then Desktop session "org-agenda-list" should exist

    Given I start an action chain
    And     I press "M-x"
    And     I type "org-agenda"
    And     I press "RET"
    And     I press "a"
    And     I execute the action chain
    Then Buffer "*Org Agenda*" should exist

    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-load" RET "org-agenda-list" RET
    Then Buffer "*Org Agenda*" should exist

    Given I switch to buffer "*Org Agenda*"
    Then I should see "Monday"


  Scenario: Handle org todo buffer
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "org-todo-list" RET
    Then Desktop session "org-todo-list" should exist

    Given I start an action chain
    And     I press "M-x"
    And     I type "org-agenda"
    And     I press "RET"
    And     I press "t"
    And     I execute the action chain
    Then Buffer "*Org Agenda*" should exist

    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-load" RET "org-todo-list" RET
    Then Buffer "*Org Agenda*" should exist

    Given I switch to buffer "*Org Agenda*"
    Then I should see "TODO"


  Scenario: Handle man buffer
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "man" RET
    Then Desktop session "man" should exist

    When  I start an action chain
    And    I press "M-x"
    And    I type "man"
    And    I press "RET cat"
    And    I execute the action chain
    Given I sleep for "1" second
    Then Buffer "*Man cat*" should exist

    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-load" RET "man" RET
    Given I sleep for "1" second
    Then Buffer "*Man cat*" should exist

    Given I switch to buffer "*Man cat*"
    Then I should see "CAT"


  Scenario: Handle shell directory
    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-save" RET "shell" RET
    Then Desktop session "shell" should exist

    When I switch to directory "/tmp"
    When  I start an action chain
    And    I press "M-x"
    And    I type "shell"
    And    I press "RET"
    And    I execute the action chain

    Given I am in a fresh Emacs instance
    When I call M-x "desktop+-load" RET "shell" RET
    Then Buffer "*shell*" should exist
    When I switch to buffer "*shell*"
    Then Variable "default-directory" should be "/tmp/"
