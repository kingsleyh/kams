require File.dirname(__FILE__) + '/../util/platform'

describe Platform do

  PLATFORM_LIST = {:windows => %w(mswin msys mingw cygwin bccwin wince emc), :linux => %w(linux), :unix => %w(solaris bsd), :mac => ['darwin','mac os']}

  it "returns the correct Windows based operating system when asked" do
    assert_platform_of_type(:windows)
  end

  it "returns the correct Linux based operating system when asked" do
    assert_platform_of_type(:linux)
  end

  it "returns the correct Unix based operating system when asked" do
    assert_platform_of_type(:unix)
  end

  it "returns the correct Mac based operating system when asked" do
    assert_platform_of_type(:mac)
  end

  it "raises error if detected os is not recognised" do
    platform = Platform.new("unknown")
    expect { platform.os }.to raise_error(RuntimeError, 'Error detected operating system is unknown: "unknown"')
  end

  private
  def assert_platform_of_type(platform_type)
    PLATFORM_LIST[platform_type].each do |platform|
      detected_platform = Platform.new(platform)
      detected_platform.os == platform_type

      if platform_type == :windows
        detected_platform.is_windows? == true
        detected_platform.is_nix? == false
      end

      if platform_type != :windows
        detected_platform.is_windows? == false
        detected_platform.is_nix? == true
      end
    end
  end

end