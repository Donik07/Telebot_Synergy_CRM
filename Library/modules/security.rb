class General_bot
  module Listener
    module Security
      # Метод проверяет, из активной ли сессии пришёл запрос.
      def message_is_new?(start_time, message)
        message_time = (defined? message.date) ? message.date : message.message.date
        message_time.to_i > start_time
      end

      def token_is_valid?(request)
        if request['errors']
          false
        else
          true
        end
      end

      module_function(
        :message_is_new?,
        :token_is_valid?
      )
    end
  end
end