class General_bot
  module Listener

    module Sample_messages
      def sample_messages
        messages = {
          msg_start: 'Добро пожаловать в официальный телеграм бот Synergy CRM!',
          msg_start2: 'Открывайте меню и выбирайте всё что захочется!',
          msg_help: 'Нужна помощь? Кликните по ссылке @synergy_hde_bot и напишите нашим специалистам.',
          msg_g_menu_description: 'Выберите действие:',
          msg_g_menu_create: 'Создать +',
          msg_g_menu_read: 'Просмотреть...',
          msg_g_menu_settings: 'Настройки',
          msg_unknown_command: 'Я пока ещё не знаю такой команды...',
          msg_create_contact_fio: 'Введите ФИО:',
          msg_create_contact_phone: 'Введите номер телефона:',
          msg_create_contact_email: 'Введите E-mail:',
          msg_select_object: 'Что будем создавать?',
          msg_object_contact: 'Контакт',
          msg_object_company: 'Компания',
          msg_object_task: 'Задача',
          msg_object_lead: 'Заявка'
        }
      end

      module_function(:sample_messages)
    end

  end
end
