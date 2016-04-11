require 'capybara/poltergeist'
require 'mechanize'
require 'pry'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: false)
end

Capybara.default_driver = :poltergeist

browser = Capybara.current_session
url = "http://meettheipsums.com/"
browser.visit url

array_ipsum = Array.new
browser.all("li").each do |item|
  ipsum = item.find("div.title").text
  sample = item.find("div.sample").text
  url = item.find("div.link a")['href']
  array_ipsum << [ipsum, url, sample]
end
random = Random.new

array_ipsum.each do |inner|
    agent = Mechanize.new
    page = agent.get('http://localhost:3000/products/new')
    product_form = page.form
    product_form.field_with(:name => 'product[title]').value = inner.first
    # binding.pry
    # product_form.field_with(:name => 'product[image_url]').value = inner[1]
    pic = inner[0].split(" ").first.downcase
    product_form.field_with(:name => 'product[image_url]').value = "#{pic}.gif"
    product_form.field_with(:name => 'product[description]').value = inner.last
    product_form.field_with(:name => 'product[price]').value = random.rand(100.5).round(2)
    product_form.click_button
end