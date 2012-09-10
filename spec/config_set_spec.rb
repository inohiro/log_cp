require 'spec_helper'
require 'log_cp'

describe 'config_set' do

  before :all do
#    @config_path = './config.yml'
  end

  context 'create instance' do
    it 'succesfully' do
      config = ConfigSet.new( CONFIG_PATH )
      config.should_not eq nil
    end

    it 'has pgoram_dir' do
      config = ConfigSet.new( CONFIG_PATH )
      config.program_dir.should eq '/Users/inohiro/github/log_cp/spec'
    end

    it 'has program-log' do
      config = ConfigSet.new( CONFIG_PATH )
      config.program_log.should eq '/Users/inohiro/github/log_cp/spec/data'
    end

    it 'has log_dir_name' do
      config = ConfigSet.new( CONFIG_PATH )
      config.log_dir_name.should eq '/Users/inohiro/github/log_cp/spec/data/dest'
    end

  end
end
