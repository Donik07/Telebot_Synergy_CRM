# frozen_string_literal: true
class General_bot
  module Listener

    module StandartMessages
      def process
        message = Listener.message
        bot = Listener.bot

        case message.text
        when '/start'
          bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_start])
          # Проверяем, авторизован ли пользователь
          if Listener.user_auth?
            bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_start2])
          end

        when '/help'
          bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_help])

        when '/menu'
          return unless Listener.user_auth?
          open_menu(bot, message)

        else
          # Если пользователь прислал нам сообщение из 64-ёх символов, считаем что нам прислали токен.
          if message.text.length == 64
            user_name = message.from.username
            user_id = message.from.id
            token = message.text
            # Сохраняем в БД нового пользователя, если его не существует.
            # Если пользователь существует, заменяем его токен на новый.
            if Database.auth?(user_id)
              Database.change_token(user_id, token)
            else
              Database.new_user(user_name, user_id, token)
            end
            bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_success_registration])
            bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_start2])
            return
          end

          bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_unknown_command])
          # bot.api.sendMessage(chat_id: message.chat.id, text: message.sticker.file_id)
        end
      end

      def open_menu(bot, message)
        inline_button = Telegram::Bot::Types::InlineKeyboardButton
        inline_markup = Telegram::Bot::Types::InlineKeyboardMarkup

        kb = [
          inline_button.new(text: $sample_msg[:msg_g_menu_create], callback_data: 'create'),
          inline_button.new(text: $sample_msg[:msg_g_menu_read], callback_data: 'read'),
          inline_button.new(text: $sample_msg[:msg_g_menu_settings], callback_data: 'settings')
        ]
        markup = inline_markup.new(inline_keyboard: kb)

        if message.from.is_bot
          bot.api.deleteMessage(chat_id: message.chat.id, message_id: message.message_id)
          bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_g_menu_description],
                              reply_markup: markup)
        else
          bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_g_menu_description],
                              reply_markup: markup)
        end
      end

      # Функция выводит на экран результаты обращения к API.
      def send_result_for_api(hash)
        message = CallbackMessages.callback_message
        bot = Listener.bot
        @res_message = ''

        hash.each do |k, v|
          @res_message = @res_message + "#{k} - #{v} \n"
        end
        bot.api.sendMessage(chat_id: message.chat.id, text: "#{@res_message}")
      end

      # Отправка сообщения о некорректном токене
      def incorrect_token
        message = CallbackMessages.callback_message
        bot = Listener.bot
        bot.api.sendMessage(chat_id: message.chat.id, text: $sample_msg[:msg_incorrect_token])
      end


      module_function(
        :process,
        :open_menu,
        :send_result_for_api,
        :incorrect_token
      )
    end

  end
end

