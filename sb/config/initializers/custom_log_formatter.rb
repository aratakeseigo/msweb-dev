class Logger::FormatWithTime < Logger::Formatter
  include ActiveSupport::TaggedLogging::Formatter

  def call(level, timestamp, progname, msg)
    [].tap do |arr|
      arr << "time:#{timestamp.strftime("%Y/%m/%d %H:%M:%S")}"
      arr << "level:#{level}"
      arr << "progname:#{progname}" if progname
      if String === msg
        arr << "message:#{msg.chomp}"
      else
        arr << "message:#{msg.inspect.chomp}"
      end
    end.join("\t").chomp + "\n"
  end
end

module Rails
  module Rack
    class Logger < ActiveSupport::LogSubscriber
      def started_request_message(request)
        [
          "method:#{request.request_method}",
          "path:#{request.filtered_path}",
          "host:#{request.ip}",
        ].join("\t")
      end
    end
  end
end

Rails.logger.formatter = Logger::FormatWithTime.new
