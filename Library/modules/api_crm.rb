class General_bot
  module Listener

    module Api_crm
      def create_contact(fio, tel)
        url = URI("https://app.syncrm.ru/api/v1/contacts")

        https = Net::HTTP.new(url.host, url.port)
        https.use_ssl = true

        request = Net::HTTP::Post.new(url)
        request["Content-Type"] = "application/vnd.api+json"
        request["Authorization"] = "Bearer 62e44c6d4c5f3a8d947577030aba6a1960d847f85f2fe5d3f89dd58ea962258b"

        request.body = {
          "data":{
            "type":"contacts",
            "attributes":{
              "first-name":"#{fio}",
              "general-phone":"#{tel}"
            },
          }
        }.to_json

        response = https.request(request)
        puts response.read_body
      end
      module_function(
      :create_contact
      )
    end

  end
end
