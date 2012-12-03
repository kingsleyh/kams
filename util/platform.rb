require 'rbconfig'

class Platform

  def self.os
    host_os = RbConfig::CONFIG['host_os']
    case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise RuntimeError, "unknown os: #{host_os.inspect}"
    end
  end

  def self.is_windows?
    os == :windows
  end

  def self.is_nix?
    os != :windows
  end

end