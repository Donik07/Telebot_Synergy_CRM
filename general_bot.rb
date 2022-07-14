# require 'telegram/bot'
# #require './library/modules/standard_messages'
#
# token = '5445808153:AAFyTSBcOWusk5gNYKpBbeeFo8ha-S-TNTY'
# Telegram::Bot::Client.run(token) do |bot|
#   bot.listen do |message|
#     if message.text == '/start'
#       bot.api.sendMessage(chat_id: message.chat.id, text: "Добро пожаловать в официальный телеграм бот Synergy CRM!")
#     elsif message.text == '/help'
#       bot.api.sendMessage(chat_id: message.chat.id, text: "Нужна помощь? Кликните по ссылке @synergy_hde_bot и напишите нашим специалистам!")
#       # bot.api.deleteMessage(chat_id: message.chat.id, message_id: message.message_id)
#       bot.api.editMessageText(chat_id: message.chat.id, message_id: message.message_id, text: "Всё очень круто! Ваша CRM работает как надо! Могёте!")
#     end
#   end
# end
#
#
require 'telegram/bot'
require './library/mac-shake'
require './library/standart_messages'
require './library/callback_messages'
require './library/modules/listener'
require './library/modules/sample_messages'
require './library/modules/api_crm'

require 'uri'
require 'net/http'
require 'json/ext'


class General_bot
  def initialize
    Telegram::Bot::Client.run(TelegramInfo::API_KEY) do |bot|
      bot.listen do |message|
        Listener.catch_new_message(message, bot)
      end
    end
  end
end

General_bot.new