class NoticeMailer < ActionMailer::Base

    admins = User.find_all_by_role_id(1)
    adminemails = Array.new
    for admin in admins do
      adminemails << admin.email
    end

  def inform_user(user, betreff, text, sent_at = Time.now)
    
    #Loggertest
    logfile = File.open('d:/ruby/ip/log/audit.log', 'a')    
    audit_log = AuditLogger.new(logfile) 
    audit_log.info 'inform user wurde aufgerufen'
    
    subject    betreff
    recipients "#{user.email}"
    from       'TomNielson@gmail.com'
    sent_on    sent_at
    
    body       :greeting => "Hallo #{user.firstname} #{user.lastname},", :message => text 
  end

  def inform_admin(betreff, text, sent_at = Time.now)
    subject    betreff
    recipients adminemails
    from       'TomNielson@gmail.com'
    sent_on    sent_at
    
    body       :greeting => 'Hallo Admin(s) der IP-DB,', :message => text          
  end

end
