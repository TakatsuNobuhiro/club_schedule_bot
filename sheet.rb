require "google_drive"
 
session = GoogleDrive::Session.from_config("config.json")
 
# https://docs.google.com/spreadsheets/d/xxxxxxxxxxxxxxxxxxxxxxxxxxx/
# 事前に書き込みたいスプレッドシートを作成し、上記スプレッドシートのURL(「xxx」の部分)を以下のように指定する
sheets = session.spreadsheet_by_key("13WA_Q3VpsYsBuOpFqBjaACSoSnL4pqXLNe0evAPRjWs").worksheets[0]

# スプレッドシートへの書き込み
sheets[1,2] = "hello world!!"
 
# シートの保存
sheets.save