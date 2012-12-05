require 'log4r'

class LogFile

  def self.log
    include Log4r
    logger = Logger.new "log-file"
    logger.outputters << Outputter.stdout
    logger.outputters << FileOutputter.new('automation-log', :filename =>  'automation.log')
    logger
  end

end