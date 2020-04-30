class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.connection_pool.clear_reloadable_connections!

  sql = "select * from Identity"
  records_array = ActiveRecord::Base.connection.execute(sql);

  records_array.each{|mysql_result| puts mysql_result}

end
