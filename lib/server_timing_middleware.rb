# This simple Rack middleware subscribes to all AS::Notifications
# and adds the appropriate `Server-Timing` header as described in
# the spec [1] with the notifications grouped by name and with the
# elapsed time added up.
#
# [1] Server Timing spec: https://w3c.github.io/server-timing/

module Rack
  class ServerTimingMiddleware
    def initialize(app)
      @app = app
    end
    def call(env)

      events = []

      subs = ActiveSupport::Notifications.subscribe(//) do |*args|
        events << ActiveSupport::Notifications::Event.new(*args)
      end

      status, headers, body = @app.call(env)

      # As the doc states, this harms the internal AS:Notifications
      # caches, but I'd say it's necessary so we don't leak memory
      ActiveSupport::Notifications.unsubscribe(subs)

      rails_runtime = nil

      mapped_events = events.group_by { |el|
        el.name
      }.map{ |event_name, event_data|
        agg_time = event_data.map{ |ev|
          ev.duration
        }.inject(0){ |curr, accum| curr += accum}

        # store a copy of this so we can figure out how much time our middleware
        # is taking
        if (event_name == 'process_action.action_controller')
          rails_runtime = agg_time
        end

        # We need the string formatter as the scientific notation
        # a.k.a <number>e[+-]<exponent> is not allowed
        [event_name, '%.10f' % agg_time]
      }

      # we can only get this if we insert our middleware before Rack::Runtime
      if headers['X-Runtime']
        # if x-runtime is set also set it here
        runtime = headers['X-Runtime'].to_f * 1000
        mapped_events.push(['runtime.rack', '%.10f' % runtime])

        # and if we also have rails_runtime then the difference between these two
        # is the time it takes to run the rack middleware stack between rails and
        # us
        if (rails_runtime)
          mapped_events.push(['middleware.rack', '%.10f' % (runtime - rails_runtime)])
        end
      end

      # Example output:
      #   'cpu;dur=0.009, mysql;dur=0.005, filesystem;dur=0.006'
      headers['Server-Timing'] = mapped_events.map do |name, elapsed_time|
        "#{name};dur=#{elapsed_time}"
      end.join(', ')

      [status, headers, body]
    end
  end
end

require 'server_timing_middleware/railtie' if defined?(Rails)
