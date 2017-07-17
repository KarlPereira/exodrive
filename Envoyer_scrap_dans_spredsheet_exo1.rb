require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'google_drive'

page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))   

session = GoogleDrive::Session.from_service_account_key("client_secret.json")
feuille1 = session.spreadsheet_by_key("1OV2SAihx0gAauCJIksPuH4dLzxpIDKWkDw0qT9ROc0U").worksheets[0]


tab = {}
i = 1
while(i<973)
    name = page.xpath("//*[@id=\"currencies-all\"]/tbody/tr[#{i}]/td[2]/img/@alt")
    price = page.xpath("//*[@id=\"currencies-all\"]/tbody/tr[#{i}]/td[5]/a/@data-usd")
    i += 1
    tab.store(name.text, price.text) 
end
    puts tab

i2 = 2
feuille1["A1"] = "Monnaie"
feuille1["B1"] = "Valeur"
tab.each { |cle, valeur|
    feuille1["A#{i2}"] = cle
    feuille1["B#{i2}"] = tab[cle]
    i2 += 1
    }
p feuille1[5, 1]
feuille1.save