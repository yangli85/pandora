#encoding:utf-8
module Pandora
  module Common
    module TimeHelper
      def relative_time(start_time)
        diff_seconds = ((Time.now - start_time)* 24 * 60 * 60).to_i
        case diff_seconds
          when 0 .. 59
            "1分钟内"
          when 60 .. (3600-1)
            "#{(diff_seconds/60)}分钟前"
          when 3600 .. (3600*24-1)
            "#{diff_seconds/3600}小时前"
          when (3600*24) .. (3600*24*30)
            "#{diff_seconds/(3600*24)}天前"
          else
            start_time.strftime("%Y/%m/%d")
        end
      end
    end
  end
end
