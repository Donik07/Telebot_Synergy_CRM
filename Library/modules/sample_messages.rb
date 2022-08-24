# frozen_string_literal: true
class General_bot
  module Listener

    module Sample_messages
      def sample_messages
        messages = {
          msg_start: 'Добро пожаловать в официальный телеграм бот Synergy CRM!',
          msg_start2: 'Открывайте меню и выбирайте всё что захочется!',
          msg_unknown_user: 'Кажется мы с вами ещё не знакомы...',
          msg_unknown_user2: 'Отправьте нам API-токен от Вашего аккаунта CRM для корректной работы!',
          msg_success_registration: 'Отлично! Токен сохранён!',
          msg_help: 'Нужна помощь? Кликните по ссылке @synergy_hde_bot и напишите нашим специалистам.',
          msg_g_menu_description: 'Выберите действие:',
          msg_g_menu_create: 'Создать +',
          msg_g_menu_read: 'Просмотреть...',
          msg_g_menu_settings: 'Настройки',
          msg_select_create: 'Что будем создавать?',
          msg_select_read: 'Что будем смотреть?',
          msg_object_contact: 'Контакт',
          msg_contact_added: 'Контакт сохранён!',
          msg_object_company: 'Компания',
          msg_company_added: 'Компания создана!',
          msg_object_task: 'Задача',
          msg_task_added: 'Задача поставлена!',
          msg_object_lead: 'Заявка',
          msg_lead_added: 'Заявка создана!',
          msg_create_contact_fio: 'Введите ФИО:',
          msg_create_contact_phone: 'Введите номер телефона:',
          msg_create_contact_email: 'Введите E-mail:',
          msg_create_company_name: 'Введите название компании:',
          msg_create_company_phone: 'Введите номер телефона компании:',
          msg_create_company_inn: 'Введите ИНН компании:',
          msg_create_task_name: 'Введите название задачи:',
          msg_create_task_desc: 'Введите описание задачи:',
          msg_create_lead_name: 'Введите название заявки:',
          msg_create_lead_desc: 'Введите название заявки:',
          msg_create_lead_fio: 'Введите ФИО контактного лица:',
          msg_create_more: 'Создать ещё +',
          msg_read_more: 'Просмотреть ещё...',
          msg_open_menu: 'Меню',
          msg_unknown_command: 'Я пока ещё не знаю такой команды...',
          msg_incorrect_token: 'Некорректный токен! Попробуйте отправить ваш токен ещё раз'
        }
      end

      module_function(:sample_messages)
    end

  end
end
