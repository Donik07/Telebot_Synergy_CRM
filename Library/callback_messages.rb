# frozen_string_literal: true
class General_bot
  module Listener

    module CallbackMessages
      attr_accessor :callback_message

      def process
        inline_button = Telegram::Bot::Types::InlineKeyboardButton
        inline_markup = Telegram::Bot::Types::InlineKeyboardMarkup
        message = Listener.message
        bot = Listener.bot
        self.callback_message = message.message
        @user_id = message.from.id

        case message.data
        when 'create'
          kb = [
            inline_button.new(text: $sample_msg[:msg_object_contact], callback_data: 'create_contact'),
            inline_button.new(text: $sample_msg[:msg_object_company], callback_data: 'create_company'),
            inline_button.new(text: $sample_msg[:msg_object_task], callback_data: 'create_task'),
            inline_button.new(text: $sample_msg[:msg_object_lead], callback_data: 'create_lead')
          ]
          markup = inline_markup.new(inline_keyboard: kb)
          bot.api.editMessageReplyMarkup(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id,
                                         reply_markup: markup)

        when 'read'
          kb = [
            inline_button.new(text: $sample_msg[:msg_object_contact], callback_data: 'read_contact'),
            inline_button.new(text: $sample_msg[:msg_object_company], callback_data: 'read_company'),
            inline_button.new(text: $sample_msg[:msg_object_task], callback_data: 'read_task'),
            inline_button.new(text: $sample_msg[:msg_object_lead], callback_data: 'read_lead')
          ]
          markup = inline_markup.new(inline_keyboard: kb)
          bot.api.editMessageReplyMarkup(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id,
                                         reply_markup: markup)

        when 'create_contact'
          bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)
          create_contact(bot)

        when 'read_contact'
          bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)
          read_contact(bot)

        when 'create_company'
          bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)
          create_company(bot)

        when 'create_task'
          bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)
          create_task(bot)

        when 'create_lead'
          bot.api.deleteMessage(chat_id: self.callback_message.chat.id, message_id: self.callback_message.message_id)
          create_lead(bot)

        when 'settings'
          sticker_id = 'CAACAgIAAxkBAAIB02LINQ3TyvIiK1nW5mi-5vfxYaGnAAJOAgACVp29CjD-a22BMgNvKQQ'
          bot.api.sendSticker(chat_id: self.callback_message.chat.id, sticker: sticker_id)

        else
          StandartMessages.open_menu(bot, self.callback_message)
        end
      end

      # Функция слушает сообщения от пользователя
      def get_message(bot)
        bot.listen do |answer|
          # Останавливаем прослушивание сообщений если поймали кнопку break
          if answer == '/break'
            return
          else
            return answer if answer
          end
        end
      end

      # параметр reversible показывает, вызывается ли функция внутри других методов, для связи объектов в CRM.
      def create_contact(bot, reversible = false)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_contact_fio])
        fio = get_message(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_contact_phone])
        tel = get_message(bot)
        # Результат функции вернёт нам id созданного объекта
        created_contact_id = Api_crm::head(TelegramInfo::CONTACT, 'create_contact', @user_id, fio, tel)

        # Если функция вызывается для связи объектов в CRM, то мы вовзращаем ID только что соданного объекта как результат
        # Иначе показываем небольшую менюшку "Создать ещё" или "Вернуться в меню"
        unless reversible
          return create_more_or_menu(bot, 'contact', "#{$sample_msg[:msg_contact_added]}", 'create')
        end
        created_contact_id
      end

      def read_contact(bot)
        Api_crm::head(TelegramInfo::CONTACT, 'read', @user_id)
        create_more_or_menu(bot, 'contact', "#{$sample_msg[:msg_g_menu_description]}", 'read')
      end

      def create_company(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_company_name])
        company_name = get_message(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_company_phone])
        tel = get_message(bot)
        Api_crm::head(TelegramInfo::COMPANY, 'create_company', @user_id, company_name, tel)
        create_more_or_menu(bot, 'company', "#{$sample_msg[:msg_company_added]}", 'create')
      end

      def create_task(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_task_name])
        task_name = get_message(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_task_desc])
        task_desc = get_message(bot)
        Api_crm::head(TelegramInfo::TASK, 'create_task', @user_id, task_name, task_desc)
        create_more_or_menu(bot, 'task', "#{$sample_msg[:msg_task_added]}", 'create')
      end

      def create_lead(bot)
        bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: $sample_msg[:msg_create_lead_name])
        lead_name = get_message(bot)
        created_contact_id = create_contact(bot, true)
        Api_crm::head(TelegramInfo::LEAD, 'create_lead', @user_id, lead_name, created_contact_id.to_i)
        create_more_or_menu(bot, 'lead', "#{$sample_msg[:msg_lead_added]}", 'create')
      end

      def create_more_or_menu(bot, obj, msg, cmd)
        inline_button = Telegram::Bot::Types::InlineKeyboardButton
        inline_markup = Telegram::Bot::Types::InlineKeyboardMarkup
        if cmd == 'create'
          kb = [
            inline_button.new(text: $sample_msg[:msg_create_more], callback_data: "create_#{obj}"),
            inline_button.new(text: $sample_msg[:msg_open_menu], callback_data: 'open_menu')
          ]
        else
          kb = [
            inline_button.new(text: $sample_msg[:msg_read_more], callback_data: "read_#{obj}"),
            inline_button.new(text: $sample_msg[:msg_open_menu], callback_data: 'open_menu')
          ]
        end
          markup = inline_markup.new(inline_keyboard: kb)
          bot.api.sendMessage(chat_id: self.callback_message.chat.id, text: "#{msg}", reply_markup: markup)
      end

      module_function(
        :process,
        :callback_message,
        :callback_message=,
        :get_message,
        :create_contact,
        :read_contact,
        :create_company,
        :create_task,
        :create_lead,
        :create_more_or_menu
      )
    end
  end
end
