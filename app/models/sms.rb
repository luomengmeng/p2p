#coding=utf-8
class Sms

  def self.send_verify_code(mobile, verify_code)
  	p "@@@@@@@@#{verify_code}@@@@@@@@@#{mobile}"
    JuheSms.send_verify_code(mobile, verify_code)
  end

end