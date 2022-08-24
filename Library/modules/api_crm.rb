# frozen_string_literal: true
class General_bot
  module Listener

    module Api_crm
      # Главная функция, которая обрабатывает все обращения к API
      def head(uri, cmd, user_id, *args)
        @url = URI(uri)
        @read = false

        case cmd
        when 'create_contact'
          @request = Net::HTTP::Post.new(@url)
          @request.body = create_contact(*args)

        when 'create_company'
          @request = Net::HTTP::Post.new(@url)
          @request.body = create_company(*args)

        when 'create_task'
          @request = Net::HTTP::Post.new(@url)
          @request.body = create_task(*args)

        when 'create_lead'
          @request = Net::HTTP::Post.new(@url)
          @request.body = create_lead(*args)

        when 'read'
          @url += URI("?page[size]=25")
          @request = Net::HTTP::Get.new(@url)
          @read = true
        end

        token = Database.get_token(user_id)
        @request["Content-Type"] = "application/vnd.api+json"
        @request["Authorization"] = "Bearer #{token}"

        https = Net::HTTP.new(@url.host, @url.port)
        https.use_ssl = true
        res = https.request(@request)

        parse_json(res, @read)
      end

      # Метод парсит передаваемый в него json
      def parse_json(request, read)
        res_json_parse = JSON.parse(request.read_body)
        puts res_json_parse

        # Проверяем валиден ли токен юзера, если нет - отправляем ошибку.
        if Security.token_is_valid?(res_json_parse)
          puts Security.token_is_valid?(res_json_parse)
          if read
            read_obj_in_json(res_json_parse)
          else
            res_json_obj_id = res_json_parse.dig 'data', 'id'

            res_json_obj_id.to_i
          end
        else
          StandartMessages.incorrect_token
        end
      end

      # Метод распознаёт тип присланного json и исходя из этого, достаёт полезные параметры
      def read_obj_in_json(json)
        object_type = json.dig 'data', 0, 'type'
        if object_type == 'contacts'
          result = read_contact(json)
          StandartMessages.send_result_for_api(result)
        else
          puts 'Incorrect type!'
        end
      end

      # Достаём полезные данные контакта из json.
      def read_contact(json)
        data = Hash.new
        json['data'].each do |hash|
          hash['attributes'].each do |k, v|
            @first_name = v if k == 'first-name'
            @last_name = v if k == 'last-name'
            @general_phone = v if k == 'general-phone'

            if @last_name == nil
              @fio = @first_name
            else
              @fio = @first_name.to_s + ' ' + @last_name.to_s
            end
          end
          data[:"#{@fio}"] = @general_phone
        end
        data
      end

      def create_contact(fio, tel)
        {
          "data":{
            "type":"contacts",
            "attributes":{
              "first-name":"#{fio}",
              "general-phone":"#{tel}"
            },
          }
        }.to_json
      end

      def create_company(name, tel)
        {
          "data":{
            "type":"companies",
            "attributes":{
              "name":"#{name}",
              "general-phone":"#{tel}"
            },
          }
        }.to_json
      end

      def create_task(name, desc)
        {
          "data":{
            "type":"diary-tasks",
            "attributes":{
              "name":"#{name}",
              "description":"#{desc}"
            },
          }
        }.to_json
      end

      def create_lead(name, id_contact)
        {
          "data":{
            "type":"orders",
            "attributes":{
              "name":"#{name}",
            },
            "relationships":{
              "contacts":{
                "data":[{
                "type":"contacts",
                "id": id_contact
                }]
              }
            }
          }
        }.to_json
      end

      module_function(
        :head,
        :create_contact,
        :create_company,
        :create_task,
        :create_lead,
        :parse_json,
        :read_obj_in_json,
        :read_contact,
      )
    end

  end
end
