# -*- coding: utf-8 -*-
require 'fileutils'
require 'pp'


module LogCp

  class LogManager

    def initialize( config, logger = Logger.new( './log_cp.log' ) )
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
#        FileUtils.cp( f, dir_name ) # 上書き移動
      end
    end

    def remove_old_logs( limit_month = 100 )
      Dir.glob( @config.log_dir_name + '/*'  ) do |dir|
        created_month = get_created_month( dir )
        result = too_old?( created_month, limit_month )

        pp dir
        pp result
        
        if result
          FileUtils.rm_r( File.expand_path( dir ) )
        end
      end
    end

    private

    def too_old?( created_month, limit_month = 100 )
      current_month = get_current_month.to_i
      current_month - created_month.to_i >= limit_month ? true : false
    end

    def get_current_month
      now = Time.now
      if now.month.to_s.length == 1
        "#{now.year}0#{now.month}"
      else
        "#{now.year}#{now.month}"
      end
    end

    def get_created_month( file )
      m = file.match( /\d\d\d\d\d\d/ )
      if m
        m[0]
      else
        nil
      end
    end

    def create_dir( dir = @config.program_log )
      # ログフォルダが存在しなければ作成する
      unless File.exists? dir
        FileUtils.mkdir_p( dir )
      end
    end

  end

end
