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
              msg = { :status => "[]"}
              format.json  { render :json => msg } # don't do msg.to_json
            end    

        else  
            respond_to do |format|
              msg = { :status => "1", :data => founduser}
              format.json  { render :json => msg } # don't do msg.to_json
          
            end
        end
    end

    def createuser
            sql = "insert into Identity (handle, password, fullname, location, email, bdate, joined) 
                   values('#{params[:handle]}', '#{params[:password]}', '#{params[:fullname]}', '#{params[:location]}', '#{params[:email]}', '#{params[:bdate]}', now());"

            sqlOutput = "select idnum from Identity where handle = '#{params[:handle]}'"
            begin
            userCreated = ActiveRecord::Base.connection.exec_query(sql);
            rescue
              respond_to do |format|
                msg = { :status => "-2", :error => "SQL Constraint Exception"}
                format.json  { render :json => msg } # don't do msg.to_json
      
              end
            else
            userDone = ActiveRecord::Base.connection.exec_query(sqlOutput);
            respond_to do |format|
              msg = { :status => userDone.rows}
              format.json  { render :json => msg } # don't do msg.to_json
            end
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
      begin
      unfol = ActiveRecord::Base.connection.exec_query(dlSQL);
      rescue
        respond_to do |format|
          msg = { :status => "Currently not followed"}
          format.json  { render :json => msg } # don't do msg.to_json
        end 
      end
      respond_to do |format|
        msg = { :status => "Unfollowed"}
        format.json  { render :json => msg } # don't do msg.to_json
      end          
    end
    end

    def follow
      authverification = param_auth(params[:handle], params[:password])
      guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
      getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;

      checkBlocked = "select handle, 
                        fullname
                        from Identity i
                        LEFT OUTER JOIN Block b ON (i.idnum = b.idnum)
                        where NOT EXISTS (select * from Block where idnum = #{params[:id]} AND blocked = #{getUser[0]["idnum"]}) AND i.idnum = #{params[:id]} GROUP BY i.idnum;"
      isblocked = ActiveRecord::Base.connection.exec_query(checkBlocked)


      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end
      elsif isblocked.blank?
        respond_to do |format|
          msg = { :status => "0", :error => "Blocked"}
          format.json  { render :json => msg } # don't do msg.to_json
        end
        
      else
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
        begin
        sendStory = ActiveRecord::Base.connection.exec_query(psSQL)
        rescue
          respond_to do |format|
            msg = { :status => "0", :error => "Invalid expires date"}
            format.json  { render :json => msg } # don't do msg.to_json
  
          end
        else
        respond_to do |format|
          msg = { :status => "1"}
          format.json  { render :json => msg } # don't do msg.to_json

        end
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
      guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
      getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
      soSQL = "select idnum from Story where sidnum = '#{params[:id]}'"
      getStoryOwner = ActiveRecord::Base.connection.exec_query(soSQL)
      checkBlocked = "select handle, 
                      fullname
                      from Identity i
                      LEFT OUTER JOIN Block b ON (i.idnum = b.idnum)
                      where NOT EXISTS (select * from Block where idnum = #{getStoryOwner[0]["idnum"]} AND blocked = #{getUser[0]["idnum"]}) AND i.idnum = #{getStoryOwner[0]["idnum"]} GROUP BY i.idnum;"
                      
      getBlocked = ActiveRecord::Base.connection.exec_query(checkBlocked);
      

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end

      elsif getBlocked.blank?
        respond_to do |format|
          msg = { :status => "0", :data => "Story not found"}
          format.json  { render :json => msg } # don't do msg.to_json
        end
      else
        if params[:likeit] != 1 and params[:likeit] !=0
          params[:likeit] = 0
        end
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

    def suggestions
      authverification = param_auth(params[:handle], params[:password])
      guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
      getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
        
      suggSQL = "select a.idnum, a.handle from Identity a
                JOIN Follows x ON(a.idnum = x.followed)
                WHERE x.follower IN (SELECT followed FROM Follows WHERE follower = #{getUser[0]["idnum"]})
                AND
                x.followed NOT IN (SELECT followed FROM Follows WHERE follower = #{getUser[0]["idnum"]})
                AND a.idnum != #{getUser[0]["idnum"]}
                GROUP BY a.idnum
                LIMIT 4;"

      getSugg = ActiveRecord::Base.connection.exec_query(suggSQL).as_json

      if authverification === '1'
        respond_to do |format|
            msg = {"status_code":"-10", "error":"invalid credentials"}
            format.json  { render :json => msg } # don't do msg.to_json
        end

      elsif getSugg.blank?
        respond_to do |format|
          msg = { :status => "0", :data => "No suggestions found"}
          format.json  { render :json => msg } # don't do msg.to_json
        end

      else
        respond_to do |format|
          msg = { :status => getSugg.size(), :data => getSugg}
          format.json  { render :json => msg } # don't do msg.to_json
        end
      end
    end

    def timeline
      guSQL = "select idnum from Identity where handle = '#{params[:handle]}'"
      getUser = ActiveRecord::Base.connection.exec_query(guSQL).as_json;
      timeLineSQL = "SELECT 'Story' status, i.idnum, i.handle Author, s.sidnum, s.chapter, s.tstamp posted FROM Story s
                    LEFT OUTER JOIN Identity i ON (s.idnum = i.idnum) 
                    LEFT OUTER JOIN Follows f ON (s.idnum = f.followed)
                    LEFT OUTER JOIN Block b on (s.idnum = b.idnum)
                    WHERE s.idnum != #{getUser[0]["idnum"]}
                    AND (f.follower = #{getUser[0]["idnum"]})
                    AND s.idnum NOT IN (SELECT idnum FROM Block WHERE blocked = #{getUser[0]["idnum"]})
                    AND s.tstamp BETWEEN '#{params[:oldest]}' AND '#{params[:newest]}'
                    GROUP BY s.sidnum
                    UNION
                    SELECT 'Reprint' status, i.idnum, i.handle Author, s.sidnum, s.chapter, s.tstamp posted FROM Story s
                    LEFT OUTER JOIN Reprint r ON (s.idnum = r.idnum)
                    LEFT OUTER JOIN Follows f ON (s.idnum = f.followed)
                    LEFT OUTER JOIN Identity i ON (s.idnum = i.idnum) 
                    WHERE r.idnum IN 
                    (SELECT followed from Follows where follower IN 
                    (SELECT followed from Follows where follower = #{getUser[0]["idnum"]}) AND
                    followed NOT IN(SELECT followed from Follows where follower = #{getUser[0]["idnum"]}))
                    AND s.idnum NOT IN (SELECT idnum FROM Block WHERE blocked = #{getUser[0]["idnum"]})
                    AND r.likeit = 0
                    AND s.tstamp BETWEEN '#{params[:oldest]}' AND '#{params[:newest]}'
                    GROUP BY s.sidnum;"
      getTimeLine = ActiveRecord::Base.connection.exec_query(timeLineSQL);

      respond_to do |format|
        msg = { :status => "1", :data => getTimeLine}
        format.json  { render :json => msg } # don't do msg.to_json
      end
      
    end
end