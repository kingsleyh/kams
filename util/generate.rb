require 'micro-optparse'
require File.expand_path(File.dirname(__FILE__) + '/log_file')
require File.expand_path(File.dirname(__FILE__) + '/core_extentions')

class Generate

  COMMAND_TYPE_LIST = %w(generic admin)

  def initialize(options)
    @options = options
  end

  def generate_command
    command = @options[:command]
    command_type = @options[:type]
    regex = @options[:regex]
    user_input = @options[:userinput]
    raise_errors(command, command_type, regex, user_input)
    generate_command_parser_code(command, command_type, regex)
    generate_command_test_code(command, command_type, regex, user_input)
  end

  def raise_errors(command, command_type, regex, user_input)
    if command.blank? or command_type.blank? or regex.blank? or user_input.blank?
      LogFile.log.info("Please supply command,type and regex: e.g. -c look_at -t generic -r '/^look\\s+(?<at>.*)$/i' -u look at tree")
      LogFile.log.info("valid types are: \n #{COMMAND_TYPE_LIST.join(' | ')}") unless COMMAND_TYPE_LIST.include?(command_type)
      exit
    end
  end

  def generate_command_test_code(command, command_type, regex, user_input)
      LogFile.log.info("Attempting to generate test code for command: #{command}")

      begin
        file_name = File.expand_path(File.dirname(__FILE__) + "/../test/specs/commands/#{command_type}_commands_spec.rb")
        file = File.readlines(file_name)
        modified = []
        last_end = find_last_end(file)
        file.each_with_index do |line, i|

          if i==last_end
            line = line.gsub("end", append_test_method(command, regex, user_input)) + "\nend"
          end

          modified << line
        end

        File.open(file_name, "w") { |f| f.puts modified.join }
        LogFile.log.info("Successfully added command test code: #{command} to: #{file_name}")
      rescue => e
        raise Exception.new("Error could not write command test file: #{file_name} with command: #{command}, :type: #{command_type} with error: #{e}")
      end

    end

  def generate_command_parser_code(command, command_type, regex)
    LogFile.log.info("Attempting to generate command: #{command}")

    begin
      file_name = File.expand_path(File.dirname(__FILE__) + "/../components/commands/#{command_type}_commands.rb")
      file = File.readlines(file_name)
      modified = []
      command_list_matcher = "Set\\.new\\(%w\\("
      command_list = "Set.new(%w("
      last_end = find_last_end(file)
      file.each_with_index do |line, i|

        if line.match(command_list_matcher)
          line = line.gsub(command_list, "#{command_list}#{command.split('_').first} ")
        end

        if i==last_end
          line = line.gsub("end", append_method(command, regex)) + "\nend"
        end

        modified << line
      end

      File.open(file_name, "w") { |f| f.puts modified.join }
      LogFile.log.info("Successfully added command: #{command} to: #{file_name}")
    rescue => e
      raise Exception.new("Error could not write command file: #{file_name} with command: #{command}, :type: #{command_type} with error: #{e}")
    end

  end

  def find_last_end(file)
    list = []
    file.each_with_index { |line, i| list << i if line.match("end") }
    list.last
  end

  def append_method(command, regex)
    tokens = find_regex_tokens(regex)
    text=<<-EOF
  def #{command}
    condition(#{regex}) do |with|
      {:action => :#{command.split('_').first}, #{tokens}} unless with.nil?
    end
  end
    EOF
  end

  def append_test_method(command, regex, user_input)
    tokens = find_regex_test_tokens(regex)
    text=<<-EOF
  it "it should parse #{command}" do
    assert_generic_command('#{user_input}',:#{command}, {:action => :#{command.split('_').first}, #{tokens}})
  end
    EOF
  end

  def find_regex_tokens(regex)
    regex.scan(/<.+?>/).collect { |i| i.gsub(/(>|<)/, "") }.collect { |t| ":#{t} => with[:#{t}]," }.join
  end

  def find_regex_test_tokens(regex)
    regex.scan(/<.+?>/).collect { |i| i.gsub(/(>|<)/, "") }.collect { |t| ":#{t} => 'some_value'," }.join
  end


end

options = Parser.new do |p|
  p.banner = "Generator! Used to generate parts of kams to relieve the manual typing"
  p.version = "Kams generator version 0.1"
  p.option :command, "name of command to generate e.g. look", :default => "", :short => "c"
  p.option :type, "type of command to generate e.g. generic", :default => "", :short => "t"
  p.option :regex, "regex for command e.g. /^look$/i", :default => "", :short => "r"
  p.option :userinput, "user input you would expect for the command .e.g look at tree", :default => "", :short => "u"
end.process!

Generate.new(options).generate_command