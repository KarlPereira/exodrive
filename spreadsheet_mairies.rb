require 'bundler'
Bundler.require
require 'json'

# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
session = GoogleDrive::Session.from_config("config.json")

# First worksheet of
# https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
ws = session.spreadsheet_by_key("code a lettre dans le lien (voir au dessus)").worksheets[0]

file = File.read('resultat.json')
mairie = JSON.parse(file)
 

# Changes content of cells.
# Changes are not sent to the server until you call ws.save().
i2 = 2
ws[1, 1] = "MAIRIES"
ws[1, 2] = "MAILS"
mairie.each { |cle, valeur|
    ws["A#{i2}"] = cle
    ws["B#{i2}"] = mairie[cle]
    i2 += 1
    }
    ws.save


ws.reload
