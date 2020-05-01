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
        guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
        getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
        authverification = param_auth(params[:handle], params[:password])
            sql = "select handle, 
            fullname, 
            location,
            email,
            bdate,
            joined 
            from Identity i
            LEFT OUTER JOIN Block b ON (i.idnum = b.idnum)
            where NOT EXISTS (select * from Block where idnum = #{params[:id]} AND blocked = #{getUser[0]["idnum"]}) AND i.idnum = #{params[:id]} GROUP BY i.idnum;"
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

    def unfollow
      
      authverification = param_auth(params[:handle], params[:password])

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end
      else
      guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
      getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
      

      dlSQL = "delete from Follows where follower = #{getUser[0]["idnum"]} and followed = #{params[:id]}"
      unfol = ActiveRecord::Base.connection.exec_query(dlSQL);

      respond_to do |format|
        msg = { :status => "Unfollowed"}
        format.json  { render :json => msg } # don't do msg.to_json
      end          
    end
  end

    def follow
      authverification = param_auth(params[:handle], params[:password])

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end
      else
      guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
      getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;


      sql = "insert into Follows 
                (follower, 
                followed, 
                tstamp) 
             values(#{getUser[0]["idnum"]},#{params[:id]},now());"

      addFollow = ActiveRecord::Base.connection.exec_query(sql)

      respond_to do |format|
        msg = { :status => "Followed"}
        format.json  { render :json => msg } # don't do msg.to_json
      end 
    end
    end

    def poststory
      authverification = param_auth(params[:handle], params[:password])

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end
      else
        guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
        getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
        
        psSQL = "Insert into Story 
                    (idnum, 
                    chapter, 
                    url, 
                    expires, 
                    tstamp) 
                 values (#{getUser[0]["idnum"]},
                         '#{params[:chapter]}', 
                         '#{params[:url]}', 
                         '#{params[:expires]}',
                         now());"
        
        sendStory = ActiveRecord::Base.connection.exec_query(psSQL)
        respond_to do |format|
          msg = { :status => "Story Posted"}
          format.json  { render :json => msg } # don't do msg.to_json
        end 
      end
    end
    
    def block
      authverification = param_auth(params[:handle], params[:password])

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end
      else
        guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
        getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
        sql = "insert into Block 
                 (idnum,
                 blocked,
                 tstamp) 
              values (#{getUser[0]["idnum"]},#{params[:id]},now());"
        
        blkUser = ActiveRecord::Base.connection.exec_query(sql)
        respond_to do |format|
          msg = { :status => "Blocked"}
          format.json  { render :json => msg } # don't do msg.to_json
        end 
      end
    end

    def reprint
      authverification = param_auth(params[:handle], params[:password])

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end
      else
        guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
        getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
        sql = "insert into Reprint
                  (idnum,
                  sidnum,
                  likeit,
                  tstamp) 
               values (#{getUser[0]["idnum"]},#{params[:id]},#{params[:likeit]},now());"
        
        doReprint = ActiveRecord::Base.connection.exec_query(sql)
        respond_to do |format|
          msg = { :status => "Reprinted"}
          format.json  { render :json => msg } # don't do msg.to_json
          end 
        end
    end
end
