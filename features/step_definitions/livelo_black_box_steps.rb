require "rspec"
require "selenium-webdriver"

# Specifying the driver path
chromedriver_path = File.join(File.absolute_path('../..', File.dirname(__FILE__)),"browsers","chromedriver.exe")
Selenium::WebDriver::Chrome::Service.driver_path = chromedriver_path

# Configuring the driver
driver = Selenium::WebDriver.for :chrome
driver.manage.window.maximize
wait = Selenium::WebDriver::Wait.new(:timeout => 60)

first_product_price = ''

Given(/^I navigate to livelo.com.br$/) do
  driver.navigate.to "https://www.livelo.com.br/"
  expect(driver.current_url).to eq "https://www.livelo.com.br/"
  log "Successfully opened the livelo website"
end

When(/^I search for (.*)$/) do |product|
  search_form = wait.until { driver.find_element(:xpath, "//*[@id='input-search']") }
  search_form.click
  search_form.send_keys product

  submit_button = wait.until { driver.find_element(:xpath, "//*[@id='span-searchIcon']")}
  submit_button.click
  sleep 10
end

Then(/^I should see the results page containing at least one product$/) do
  results = wait.until {driver.find_elements(:class, "product-list__element")}
  expect(results.length).to be >= 1
  log "#{results.length} results found. Expected 1 or more."
end

Then(/^I should see the results page containing no results$/) do
  no_results_message = wait.until {driver.find_elements(:class, "h3 not-found-text")}
  expect(no_results_message).to be
  log "No results found. Expected 0 results."
end

And(/^I click on the first result$/) do
  first_product = wait.until {driver.find_element(:class, "product-list__element")}
  first_product_price = driver.find_elements(:class, "card-value").first.text
  first_product.click
  sleep 10
end

And(/^I click on add to cart$/) do
  drop_down_options = driver.find_elements(:id, "#option-1")

  if drop_down_options.size > 0
    drop_down_options.each { |option| option.click}
  end

  add_to_cart_button = wait.until {driver.find_element(:id, "cc-prodDetails-addToCart")}
  add_to_cart_button.click
  sleep 10
end

Then(/^I should see the cart containing (.*)$/) do |product|
  wait.until {driver.find_element(:id, "cc-cart-item-0")}
  cart_item = wait.until {driver.find_element(:id, "CC-cart-list")}

  expect(cart_item.text.gsub(/\s+/, "")).to include ("Quantidade1")
  expect(cart_item.text).to include (product)
  expect(cart_item.text).to include(first_product_price)
  log "The cart contains the desired product: 1x - #{product} - #{first_product_price}"
end

And(/^I click on remove from cart$/) do
  remove_from_cart_button = wait.until {driver.find_element(:class, "cart-list__remove-item")}
  remove_from_cart_button.click
  sleep 10
end

Then(/^The (.*) should be removed$/) do |product|
  cart = wait.until {driver.find_element(:id, "CC-cart-list")}
  expect(cart.text).not_to include (product)
  log "The product was successfully removed"
end

And(/^I click on add amount$/) do
  add_amount = wait.until {driver.find_element(:class, "cart-list__iconqnt--add")}
  add_amount.click
  sleep 10
end

Then(/^I should see the amount increased by one$/) do
  amount = wait.until {driver.find_element(:class, "cart-list__value-qnt")}
  expect(amount.text). to eq ("2")
  log "Amount of the product increased. 2 items of the same product found"
end

And(/^I click on checkout$/) do
  checkout =  wait.until {driver.find_element(:class, "cart-summary__text-white")}
  checkout.click
  sleep 10
end

Then(/^I should be redirected to the login page$/) do
  login_form = wait.until {driver.find_element(:class, "login-register__group")}
  expect(login_form).to be
  log "The page redirected to a login page with success"
end
