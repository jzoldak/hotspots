module Hotspots
  module Repository
    module Driver
      class Git
        attr_reader :logger

        def initialize(logger)
          @logger = logger
        end

        def pretty_log(options)
          grep_clause = options[:message_filter].empty? ? "" : " --grep \"#{options[:message_filter]}\""
          command = %Q(git log --pretty="%H" --since #{options[:since_days]}.days.ago#{grep_clause})
            .tap {|raw| logger.log "<Input> #{raw}"}
          %x(#{command})
            .tap {|raw| logger.log raw}
        end

        def show_one_line_names(options)
          command = %Q(git show --oneline --name-only #{options[:commit_hash]})
            .tap {|raw| logger.log "<Input> #{raw}"}
          %x(#{command})
            .tap {|raw| logger.log "<Output> #{raw}"}
        end
      end
    end
  end
end
