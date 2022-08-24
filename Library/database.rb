# Этот модуль занимается всеми операциями, которые связаны с БД.
module Database
  attr_accessor :db

  require 'sqlite3'
  # Этот модуль предназначен для создания таблицы.
  module Create
    def steam_account_list
      Database.db.execute <<-SQL
        CREATE TABLE users (
        user_name VARCHAR,
        user_id INTEGER,
        token VARCHAR)
        SQL
        true
        rescue SQLite3::SQLException
          false
    end
    module_function(
      :steam_account_list
    )
  end

  def setup
    # Инициализация БД.
    self.db = SQLite3::Database.open 'users.db'
    # Пробуем обратиться к нашей таблице, если её нет, то создаём.
    unless get_table('users')
      Create.steam_account_list
    end
  end

  # Поиск по названию таблицы.
  def get_table(table_name)
    db.execute <<-SQL
      SELECT * FROM #{table_name}
    SQL
    rescue SQLite3::SQLException
      false
  end

  def auth?(user_id)
    data = db.execute <<-SQL
      SELECT * FROM users WHERE user_id like #{user_id}
    SQL

    true if data[0]
  end

  def new_user(user_name, user_id, token)
    data = db.execute <<-SQL
      INSERT INTO users (user_name, user_id, token) values("#{user_name}", "#{user_id}", "#{token}")
    SQL

    true if data[0]
  end

  def get_token(user_id)
    data = db.execute <<-SQL
      SELECT token FROM users WHERE user_id like #{user_id}
    SQL

    data[0][0]
  end

  def change_token(user_id, token)
    db.execute <<-SQL
    UPDATE users 
    SET token = "#{token}"
    WHERE user_id = #{user_id}
    SQL
  end

  module_function(
    :get_table,
    :setup,
    :db,
    :db=,
    :auth?,
    :new_user,
    :get_token,
    :change_token
  )
end
