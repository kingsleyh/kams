require File.dirname(__FILE__) + '/../../../components/commands/equipment_commands'

describe EquipmentCommands do

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