class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    sql = "select * from Identity"
  records_array = ActiveRecord::Base.connection.execute(sql);

  records_array.each{|mysql_result| puts mysql_result}
  end