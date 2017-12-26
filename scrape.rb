require 'nokogiri'
require 'yaml2sql'
require 'pry'
require 'Faraday'
require 'json'

NUMBER_OF_PAGES = 2188.freeze

def get_data_from_api

  def build_url(i)
    "https://www.poetryfoundation.org/ajax/poems?page=#{i}&sort_by=recently_added"
  end

  def data(i)
    sleep(2)
    url = build_url(i)
    res = Faraday.get(url)
    JSON.parse(res.body)
  end

  data = (2..NUMBER_OF_PAGES).map { |i| data(i) }

  File.open("data.json","w") do |f|
    f.write(JSON.pretty_generate(data))
  end
end

get_data_from_api

#text = File.read("sample.html")

#selectors = YAML.load_file('selectors.yaml')

#def parse_a_single_page(html,selectors)
  #soup = Nokogiri::HTML(html)
  #story_text = soup.css(selectors['story_text'])
  #paragraphs = story_text.map(&:text)
  #paragraphs
#end

#data = File.read('temp.json')
#json_data = JSON.parse(data)

#json_data.each do |json_obj|




#end









