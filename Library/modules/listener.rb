# frozen_string_literal: true
class General_bot
  module Listener
    attr_accessor :message, :bot

    def catch_new_message(message, bot)
      self.message = message
      self.bot = bot

      # Определяем тип отправленного нам сообщения, в зависимости от типа, подключаем нужный модуль.
      case self.message
      when Telegram::Bot::Types::CallbackQuery
        CallbackMessages.process
      when Telegram::Bot::Types::Message
        StandartMessages.process
      end
    end

    def user_auth?
      user = message.from.id
      res = true
      unless Database.auth?(user)
        bot.api.sendMessage(chat_id: message.chat.id, text: Sample_messages.sample_messages[:msg_unknown_user])
        bot.api.sendMessage(chat_id: message.chat.id, text: Sample_messages.sample_messages[:msg_unknown_user2])
        res = false
      end
      res
    end

    module_function(
      :catch_new_message,
      :message,
      :message=,
      :bot,
      :bot=,
      :user_auth?
    )
  end
end