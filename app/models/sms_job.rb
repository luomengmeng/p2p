class SmsJob
	@queue = :high

  def self.perform(job_name, mobile, code)
  	self.send(job_name, mobile, code)
  end

	def self.send_verify_code mobile, code
		p '@@@@@@@@@@@@@'
		Sms.send_verify_code(mobile, code)
	end

end