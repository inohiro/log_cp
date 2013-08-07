# -*- coding: utf-8 -*-
$:.unshift File.join( File.dirname( __FILE__ ), './../lib' )
require 'log_cp'
require 'fileutils'

LOG_FILE = './log_cp.log'

def print_help
  puts 'usage: ruby log_cp.rb config_file_path'
end

def main( argv )
  FileUtils.touch LOG_FILE unless File.exists? LOG_FILE
  logger = Logger.new( LOG_FILE )
  logger.level = Logger::ERROR

  argv.length >= 1 ? config_path = argv[0] : config_path = './config.yml'
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
