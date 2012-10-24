# -*- coding: utf-8 -*-

require 'fileutils'
require 'yaml'

ERROR_LOG = './log_cp.log'
CONFIG_FILE = './config.yml'

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

  class LogManager

    def initialize( config, logger = Logger.new( ERROR_LOG ) )
      @config = config
      @logger = logger
      @current_dir = config.log_dir_name
      create_dir # initialize
    end

    def move_logs
      create_dir( @config.program_log )
      Dir.glob( "#{@config.program_log}/" + "*.log" ) do |f|
        created_month = get_created_month( f )
        dir_name = "#{@config.log_dir_name}/#{created_month}_FastCopy_Log"
        create_dir( dir_name )
        FileUtils.mv( f, dir_name, { :force => true } ) # 上書き移動
        #        FileUtils.cp( f, dir_name ) # コピー
      end
    end

    def remove_old_logs( limit_month = 100 )
      Dir.glob( @config.log_dir_name + '/*'  ) do |dir|
        created_month = get_created_month( dir )
        result = too_old?( created_month, limit_month )
        FileUtils.rm_r( File.expand_path( dir ) ) if result
      end
    end

    private

    def too_old?( created_month, limit_month = 100 )
      current_month = get_current_month.to_i
      current_month - created_month.to_i >= limit_month ? true : false
    end

    def get_current_month
      now = Time.now
      now.month.to_s.length == 1 ? "#{now.year}0#{now.month}" : "#{now.year}#{now.month}"
    end

    def get_created_month( file )
      m = file.match( /\d\d\d\d\d\d/ )
      m != nil ? m[0] : nil
    end

    def create_dir( dir = @config.program_log )
      # ログフォルダが存在しなければ作成する
      FileUtils.mkdir_p dir unless File.exists? dir
    end
  end

end

def print_help
  puts <<EOS
usage: ruby log_cp.rb [config_file]
EOS
end

def main( argv )
  FileUtils.touch LOG_FILE unless File.exists? ERROR_LOG
  logger = Logger.new( ERROR_LOG )
  logger.level = Logger::ERROR

  argv.length >= 1 ? config_path = argv[0] : config_path = CONFIG_FILE
  config_set = LogCp::ConfigSet.new( config_path, logger )

  # 設定ファイルが正しく読めなかったら終了
  return if config_set == nil
  if config_set == nil
    logger.error( '設定ファイルが正しく読み込めませんでした' )
    puts 1
    return
  end

  # プログラムフォルダが存在しなければ終了
  unless File.exist? config_set.program_dir
    logger.error( 'プログラムフォルダが存在しません' )
    puts 2
    return
  end

  log_manager = LogCp::LogManager.new( config_set, logger )
  log_manager.move_logs
  log_manager.remove_old_logs

end

main( ARGV )
