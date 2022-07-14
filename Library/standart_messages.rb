class General_bot
  module Listener

    module StandartMessages
      def process
        inline_button = Telegram::Bot::Types::InlineKeyboardButton
        inline_markup = Telegram::Bot::Types::InlineKeyboardMarkup
        message = Listener.message
        bot = Listener.bot
        sample_msg = Sample_messages.sample_messages

        case message.text
        when '/start'
          bot.api.sendMessage(chat_id: message.chat.id, text: sample_msg[:msg_start])
          bot.api.sendMessage(chat_id: message.chat.id, text: sample_msg[:msg_start2])

        when '/help'
          bot.api.sendMessage(chat_id: message.chat.id, text: sample_msg[:msg_help])

        when '/menu'
          kb = [
            inline_button.new(text: sample_msg[:msg_g_menu_create], callback_data: 'create'),
            inline_button.new(text: sample_msg[:msg_g_menu_read], callback_data: 'reed'),
            inline_button.new(text: sample_msg[:msg_g_menu_settings], callback_data: 'settings')
          ]
          markup = inline_markup.new(inline_keyboard: kb)
          bot.api.sendMessage(chat_id: message.chat.id, text: sample_msg[:msg_g_menu_description], reply_markup: markup)

        else
          bot.api.sendMessage(chat_id: message.chat.id, text: sample_msg[:msg_unknown_command])
          # bot.api.sendMessage(chat_id: message.chat.id, text: message.sticker.file_id)
        end
      end

      module_function(
        :process
      )
    end

  end
end

