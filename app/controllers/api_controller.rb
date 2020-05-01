class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    def param_auth (*param)
        pAuth = "select * from Identity where handle = '#{param[0]}' and password = '#{param[1]}'"
        records_array = ActiveRecord::Base.connection.exec_query(pAuth);

        if records_array.blank?
                return '1'
            else
          #puts records_array.each
            return '0'
        end

    end
    def status
          
          sql = "select * from Identity where idnum = 1"
          
          status = param_auth(params[:handle], params[:password])
          if status === '1'
            respond_to do |format|
                msg = {"status_code":"-10", "error":"invalid credentials"}
                format.json  { render :json => msg } # don't do msg.to_json
            end
          else
          respond_to do |format|
            msg = { :status => "Access Granted", :Handle => params[:handle]}
            format.json  { render :json => msg } # don't do msg.to_json
          end
        end
          
    end

    def seeuser
        authverification = param_auth(params[:handle], params[:password])
            sql = "select handle, 
                          fullname, 
                          location,
                          email,
                          bdate,
                          joined 
                          from Identity where idnum = #{params[:id]}"
        founduser = ActiveRecord::Base.connection.exec_query(sql);

        if authverification === '1'
            respond_to do |format|
                msg = {"status_code":"-10", "error":"invalid credentials"}
                format.json  { render :json => msg } # don't do msg.to_json
            end
        elsif founduser.blank?
            respond_to do |format|
              msg = { :status => "Access Granted", :data => "User not found"}
              format.json  { render :json => msg } # don't do msg.to_json
            end    

        else  
            respond_to do |format|
              msg = { :status => "Access Granted", :data => founduser}
              format.json  { render :json => msg } # don't do msg.to_json
          
            end
        end
    end

    def createuser
            sql = "insert into Identity (handle, password, fullname, location, email, bdate, joined) 
                   values('#{params[:handle]}', '#{params[:password]}', '#{params[:fullname]}', '#{params[:location]}', '#{params[:email]}', '#{params[:bdate]}', now());"

            sqlOutput = "select idnum from Identity where handle = '#{params[:handle]}'"
            
            userCreated = ActiveRecord::Base.connection.exec_query(sql);
            userDone = ActiveRecord::Base.connection.exec_query(sqlOutput);
            respond_to do |format|
              msg = { :status => userDone.rows}
              format.json  { render :json => msg } # don't do msg.to_json
            end
            
    end
end
