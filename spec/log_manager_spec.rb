require 'spec_helper'
require 'logger'
require 'pp'

describe 'log_manager' do

  before :all do
    @config = LogCp::ConfigSet.new( CONFIG_PATH )
  end

  context 'create instance' do
    it 'successfully' do
      log_manager = LogCp::LogManager.new( @config )
      log_manager.should_not eq nil
    end
  end

  context 'get_current_month' do
    before :all do
      @manager = LogCp::LogManager.new( @config )
    end

    it 'get correct date' do
      now = Time.now
      str = now.month.to_s.length == 1 ? "#{now.year}0#{now.month}" : "#{now.year}#{now.month}"
      @manager.send( :get_current_month ).should eq str
    end
  end

  context 'get_created_month' do
    before :all do
      @manager = LogCp::LogManager.new( @config )
    end

    it 'can get created_month' do
      str = "20120901-040003-0.log"
      @manager.send( :get_created_month, str ).should eq '201209'
    end

    it 'can not get created_month' do
      str = '2012-09-01'
      @manager.send( :get_created_month, str ).should eq nil
    end
  end

  context 'move_logs' do

  end

  context 'remove_old_logs' do
    it 'this month' do

    end
  end

  context 'get_current_month' do
    before :all do
      @manager = LogCp::LogManager.new( @config )
    end

    it 'result size must be 6' do
      @manager.send( :get_current_month ).length.should eq 6
    end
  end

  context 'create_dir' do
    before :all do
      @manager  = LogCp::LogManager.new( @config )
    end

    it 'can create' do
      @manager = LogCp::LogManager.new( @config )
      ( File.exist? @config.program_log ).should eq false
      @manager.send( :create_dir,  @config.program_log )
      ( File.exist? @config.program_log ).should eq true
      dir_initialize
    end

    it 'can create 2' do
      ( File.exist? @config.program_log ).should eq false
      @manager.send( :create_dir )
      ( File.exist? @config.program_log ).should eq true
      dir_initialize
    end
  end
end
