# frozen_string_literal: true
require 'telegram/bot'
require './library/database'
require './library/mac-shake'
require './library/standart_messages'
require './library/callback_messages'
require './library/modules/listener'
require './library/modules/sample_messages'
require './library/modules/api_crm'
require './library/modules/security'

require 'uri'
require 'net/http'
require 'json/ext'


class General_bot
  def initialize
    Database.setup
    $sample_msg = Listener::Sample_messages.sample_messages
    Telegram::Bot::Client.run(TelegramInfo::API_KEY) do |bot|
      # Переменная хранит время запуска бота, чтобы исключить выполнение действий, которые были запрошены в предыдущей сессии.
      start_bot_time = Time.now.to_i
      bot.listen do |message|
        # Если сообщение отправлено в нынешней сессии, продолжаем выполнение кода.
        Listener.catch_new_message(message, bot) if Listener::Security::message_is_new?(start_bot_time, message)
      end
    end
  end
end

General_bot.new