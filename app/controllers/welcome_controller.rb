class WelcomeController < ApplicationController
  def index
    sql = "select * from Identity"
  records_array = ActiveRecord::Base.connection.execute(sql);

  puts records_array.each 
  end
end
