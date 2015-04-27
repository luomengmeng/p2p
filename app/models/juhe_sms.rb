#coding=utf-8
require 'xmlsimple'
require 'uri'
require "open-uri"
class JuheSms
  SENDURL = 'http://v.juhe.cn/sms/send'
  TPLID = 2292
  APPKEY = '8ca537818e6fd8d44420aa1fccd024fb'

  def self.send_verify_code(nums_str, verify_code)
  	p '$$$$$$$$$$$$$'
    open(URI::encode("#{SENDURL}?mobile=#{nums_str}&tpl_id=#{TPLID}&tpl_value=#code#=#{verify_code}&key=#{APPKEY}"))
  end

end