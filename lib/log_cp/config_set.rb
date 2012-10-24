# -*- coding: utf-8 -*-

require 'yaml'

module LogCp

  class ConfigSet

    attr_reader :program_dir
    attr_reader :program_log
    attr_reader :log_dir_name

    def initialize( config_path, logger = Logger.new( ERROR_LOG ) )
      @logger = logger

      begin
        config = YAML.load( File.open( File.expand_path( config_path ) ) )
        @program_dir = config['program_dir'] || "C:\Program Files\FastCopy"
        @program_log = config['program_log'] || "C:\Program Files\FastCopy\log"
        @log_dir_name = config['log_dir_name'] || "C:\logs"
      rescue => exp
        @logger.fatal( "Cought unecpected exception" )
        @logger.fatal( exp )
        nil
      end
    end
  end

end
