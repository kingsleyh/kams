require 'rbconfig'

class Platform

  def initialize(detected_host = RbConfig::CONFIG['host_os'])
    @host_os = detected_host
  end

  def os
    case @host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise RuntimeError, "Error detected operating system is unknown: #{@host_os.inspect}"
    end
  end

  def is_windows?
    os == :windows
  end

  def is_nix?
    os != :windows
  end

end