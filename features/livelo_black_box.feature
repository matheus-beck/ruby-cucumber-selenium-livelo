Feature: Livelo e-commerce automation
  Black box test automation about adding a product to the cart in the website of Livelo

  Scenario Outline: I should be able to search for a product in the website
    Given I navigate to livelo.com.br
    When I search for <product>
    Then I should see the results page containing at least one product

    Examples:
      | product   |
      | Ferro     |
      | Televisão |
      | Vinho     |

  Scenario Outline: The webpage shouldn't return products that doesn't exist
    Given I navigate to livelo.com.br
    When I search for <product>
    Then I should see the results page containing no results

    Examples:
      | product            |
      | 4GXuHFakeWord5     |
      | 11111111111111     |
      | NonExistingProduct |

  Scenario Outline: I should be able to add, update the amount and remove a product in the cart
    Given I navigate to livelo.com.br
    When I search for <product>
    And I click on the first result
    And I click on add to cart
    Then I should see the cart containing <product>
    When I click on add amount
    Then I should see the amount increased by one
    When I click on remove from cart
    Then The <product> should be removed

    Examples:
      | product |
      | Talher  |
      | Mixer   |
      | Tênis   |

  Scenario Outline: I should be able to finish an order
    Given I navigate to livelo.com.br
    When I search for <product>
    And I click on the first result
    And I click on add to cart
    Then I should see the cart containing <product>
    And I click on checkout
    Then I should be redirected to the login page

    Examples:
      | product |
      | Mochila |
      | Luva    |
      | Garrafa |
