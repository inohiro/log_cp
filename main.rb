# -*- coding: utf-8 -*-
$:.unshift File.join( File.dirname( __FILE__ ), 'lib' )
require 'log_cp'

def print_help
  puts <<EOS
usage: ruby log_cp.rb config_file_path
EOS
end

def main( argv )
  logger = Logger.new( './log_cp.log' )
  logger.level = Logger::ERROR

  argv.length >= 1 ? config_path = argv[0] : config_path = './config.yml'
  config_set = LogCp::ConfigSet.new( config_path, logger )

  # 設定ファイルが正しく読めなかったら終了
  return if config_set == nil
  if config_set == nil
    logger.error( '設定ファイルが正しく読み込めませんでした' )
    return
  end

  # プログラムフォルダが存在しなければ終了
  unless File.exist? config_set.program_dir
    logger.error( 'プログラムフォルダが存在しません' )
    return
  end

  log_manager = LogCp::LogManager.new( config_set, logger )
  log_manager.move_logs
  log_manager.remove_old_logs

end

main( ARGV )
