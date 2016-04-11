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

class Ipsum
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def title
    item.find("div.title").text
  end

  def sample
    item.find("div.sample").text
  end

  def url
    item.find("div.link a")['href']
  end
end

array_ipsum = Array.new

browser.all("li").each do |item|
  array_ipsum << Ipsum.new(item)
end
random = Random.new

array_ipsum.each do |ipsum|
  agent = Mechanize.new
  page = agent.get('http://localhost:3000/products/new')
  product_form = page.form
  product_form.field_with(:name => 'product[title]').value = ipsum.title
  pic = ipsum.title.split(" ").first.downcase
  product_form.field_with(:name => 'product[image_url]').value = "#{pic}.gif"
  product_form.field_with(:name => 'product[description]').value = ipsum.sample
  product_form.field_with(:name => 'product[price]').value = random.rand(100.5).round(2)
  product_form.click_button
end
