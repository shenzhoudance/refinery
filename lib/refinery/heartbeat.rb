module Refinery #:nodoc:
  # A heartbeat publisher that indicates a server is alive.
  class Heartbeat
    include Refinery::Loggable
    include Refinery::Configurable
    include Refinery::Queueable
    include Refinery::Utilities
    
    # Initialize the heartbeat for the given server.
    def initialize(server)
      queue_prefix = config['prefix'] || ''
      @server = server
      @thread = Thread.new do
        if defined?(java.lang.Thread)
          java.lang.Thread.current_thread.name = 'Heartbeat'
        end
        
        loop do
          with_queue("#{queue_prefix}heartbeat") do |heartbeat_queue|
            logger.debug "Send heartbeat"
            message = {
              'host_info' => host_info,
              'timestamp' => Time.now.utc,
              'running_daemons' => @server.daemons.length
            }
            heartbeat_queue.send_message(Base64.encode64(message.to_json))
            sleep(60)
          end
        end
      end
    end
  end
end