require "open-uri"
require "nokogiri"
require "json"

BASE_URL = "http://annuaire-des-mairies.com/"

def email_of_a_townhall(path)
  html_content = open("#{BASE_URL}#{path}")
  document = Nokogiri::HTML(html_content)
  email = document.css("body > table > tr:nth-child(3) > td > " +
                       "table > tr:first-child > td > " +
                       "table:nth-child(8) > tr:nth-child(2) > td > " +
                       "table > tr:nth-child(4) > td:nth-child(2)").text
  email.strip.gsub(" ", "")
end

# Check that first function behave as expected
# puts "- email_of_a_townhall"
# puts email_of_a_townhall("./95/vaureal.html")

def department_townhall_urls(path)
  html_content = open("#{BASE_URL}#{path}")
  document = Nokogiri::HTML(html_content)
  links = document.css("table.Style20 a.lientxt")
  links.each_with_object({}) do |node, result|
    city = node.text
    path = node["href"]
    result[city] = path
  end
end

# Check that first function behave as expected
# puts "- department_townhall_urls"
# puts department_townhall_urls("./val-d-oise.html")

# Putting pieces together
result = {}
department_townhall_urls("./val-d-oise.html").each do |city, path|
  result[city] = email_of_a_townhall(path)

  # Only do 10 of them for the example
end 
  filename = "exo2-#{Time.now.to_i}.json"

  File.open(filename, "wb") do |file|
    json_content = JSON.pretty_generate(result)
    file.write(json_content)
    break
end