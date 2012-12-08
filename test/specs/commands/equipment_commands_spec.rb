require File.dirname(__FILE__) + '/../../../components/commands/equipment_commands'

describe EquipmentCommands do

  it "should return correct category" do
    EquipmentCommands.category.should == :Clothing
    end

    it "should return correct command list" do
      EquipmentCommands.all_commands.should == Set.new(%w(wear remove))
    end

    it "should find all commands in the command list" do
      EquipmentCommands.all_commands.each do |command|
        EquipmentCommands.has_this?(command).should == true
      end
    end

    it "should not find a command that is not in the command list" do
      EquipmentCommands.has_this?('command_not_present').should == false
    end

  it "should parse wear" do
    assert_equipment_command('wear shirt', :wear, {:action => :wear, :object => 'shirt', :position => nil})
    assert_equipment_command('wear shirt on torso', :wear, {:action => :wear, :object => 'shirt', :position => 'torso'})
  end

  it "should parse remove" do
    assert_equipment_command('remove shirt', :remove, {:action => :remove, :object => 'shirt', :position => nil})
    assert_equipment_command('remove shirt from torso', :remove, {:action => :remove, :object => 'shirt', :position => 'torso'})
  end

  def assert_equipment_command(user_input, command, options)
    EquipmentCommands.new(user_input).send(command).should == options
  end

end