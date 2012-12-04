#
# Guid - Ruby library for portable GUID/UUID generation.
#
# Copyright (c) 2004 David Garamond <davegaramond at icqmail com>
#
# This library is free software; you can redistribute it and/or modify it
# under the same terms as Ruby itself.
#
#
# Note from Justin Collins: Thanks, David!
require File.dirname(__FILE__) + '/platform'
PLATFORM = Platform.new

if PLATFORM.is_windows?

  module Guid_Win32_
    require 'Win32API'

    PROV_RSA_FULL       = 1
    CRYPT_VERIFYCONTEXT = 0xF0000000
    FORMAT_MESSAGE_IGNORE_INSERTS  = 0x00000200
    FORMAT_MESSAGE_FROM_SYSTEM     = 0x00001000

    CryptAcquireContext = Win32API.new("advapi32", "CryptAcquireContext",
               'PPPII', 'L')
    CryptGenRandom = Win32API.new("advapi32", "CryptGenRandom",
          'LIP', 'L')
    CryptReleaseContext = Win32API.new("advapi32", "CryptReleaseContext",
               'LI', 'L')
    GetLastError = Win32API.new("kernel32", "GetLastError", '', 'L')
    FormatMessageA = Win32API.new("kernel32", "FormatMessageA",
          'LPLLPLPPPPPPPP', 'L')

    def lastErrorMessage
      code = GetLastError.call
      msg = "\0" * 1024
      len = FormatMessageA.call(FORMAT_MESSAGE_IGNORE_INSERTS +
              FORMAT_MESSAGE_FROM_SYSTEM, 0,
              code, 0, msg, 1024, nil, nil,
              nil, nil, nil, nil, nil, nil)
      msg[0, len].tr("\r", '').chomp
    end

    def initialize
      hProvStr = " " * 4
      if CryptAcquireContext.call(hProvStr, nil, nil, PROV_RSA_FULL,
                CRYPT_VERIFYCONTEXT) == 0
        raise SystemCallError, "CryptAcquireContext failed: #{lastErrorMessage}"
      end
      hProv, = hProvStr.unpack('L')
      @bytes = " " * 16
      if CryptGenRandom.call(hProv, 16, @bytes) == 0
        raise SystemCallError, "CryptGenRandom failed: #{lastErrorMessage}"
      end
      if CryptReleaseContext.call(hProv, 0) == 0
        raise SystemCallError, "CryptReleaseContext failed: #{lastErrorMessage}"
      end
    end
  end
else
  module Guid_Unix_
    @@random_device = nil

    def initialize
      if !@@random_device
        if File.exists? "/dev/urandom"
          @@random_device = File.open "/dev/urandom", "r"
        elsif File.exists? "/dev/random"
          @@random_device = File.open "/dev/random", "r"
        else
          raise RuntimeError, "Can't find random device"
        end
      end

      @bytes = @@random_device.read(16)
    end
  end
end

class Guid
  include PLATFORM.is_windows? ? Guid_Win32_ : Guid_Unix_

  def hexdigest
    @bytes.unpack("h*")[0]
  end

  def to_s
    if defined? ServerConfig and ServerConfig[:goid_type]
      case ServerConfig[:goid_type]
      when :hex_code
        @bytes.unpack("h6")
      when :integer_16
        rand(65536).to_s
      when :integer_24
        rand(16777216).to_s
      when :integer_32
        rand(4294967296).to_s
      else
        @bytes.unpack("h8 h4 h4 h4 h12").join "-"
      end
    else
      @bytes.unpack("h8 h4 h4 h4 h12").join "-"
    end
  end

  def inspect
    to_s
  end

  def raw
    @bytes
  end

  def self.from_s(s)
    raise ArgumentError, "Invalid GUID hexstring" unless
    s =~ /\A[0-9a-f]{8}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{4}-?[0-9a-f]{12}\z/i
    guid = Guid.allocate
    guid.instance_eval { @bytes = [s.gsub(/[^0-9a-f]+/i, '')].pack "h*" }
    guid
  end

  def self.from_raw(bytes)
    raise ArgumentError, "Invalid GUID raw bytes, length must be 16 bytes" unless
    bytes.length == 16
    guid = Guid.allocate
    guid.instance_eval { @bytes = bytes }
    guid
  end

  def ==(other)
    @bytes == other.raw
  end
end




