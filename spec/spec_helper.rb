require 'rspec'
require 'rspec/autorun'
require 'log_cp'
require 'fileutils'

CONFIG_PATH = File.expand_path( './spec/config.yml' )

RSpec.configure do |config|
  include LogCp
end

def dir_initialize
  target = []
  target << File.expand_path( './spec/data/dest' )
  target << File.expand_path( './spec/data')
  target.each do |t|
    FileUtils.rm_r( t ) if File.exist? t
  end
end

dir_initialize
