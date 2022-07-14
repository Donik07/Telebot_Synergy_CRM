class General_bot
  module Listener

    module CallbackMessages
      attr_accessor :callback_message

      def process
        inline_button = Telegram::Bot::Types::InlineKeyboardButton
        inline_markup = Telegram::Bot::Types::InlineKeyboardMarkup
        message = Listener.message
        bot = Listener.bot
        @sample_msg = Sample_messages.sample_messages
        self.callback_message = message.message

        case message.data
        when 'create'
          kb = [
            inline_button.new(text: @sample_msg[:msg_object_contact], callback_data: 'create_contact'),
            inline_button.new(text: @sample_msg[:msg_object_company], callback_data: 'create_company'),
            inline_button.new(text: @sample_msg[:msg_object_task], callback_data: 'create_task'),
            inline_button.new(text: @sample_msg[:msg_object_lead], callback_data: 'create_lead')
          ]
          markup = inline_markup.new(inline_keyboard: kb)
          bot.api.editMessageReplyMarkup(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id,
                                         text: @sample_msg[:msg_select_object], reply_markup: markup)

          # bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)

        when 'create_contact'
          bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)
          create_contact(bot)

        when 'settings'
          sticker_id = 'CAACAgIAAxkBAAIB02LINQ3TyvIiK1nW5mi-5vfxYaGnAAJOAgACVp29CjD-a22BMgNvKQQ'
          bot.api.sendSticker(chat_id: self.callback_message.chat.id, sticker: sticker_id)
        end
      end

      def get_message(bot)
        bot.listen do |answer|
          return answer if answer and answer
        end
      end

      def create_contact(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: @sample_msg[:msg_create_contact_fio])
        fio = get_message(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: @sample_msg[:msg_create_contact_phone])
        tel = get_message(bot)
        Api_crm::create_contact(fio, tel)
      end

      module_function(
        :process,
        :callback_message,
        :callback_message=,
        :get_message,
        :create_contact
      )
    end
  end
end
