module ServerTimingMiddleware
  class Railtie < Rails::Railtie
    initializer "server_timing_middleware.configure_rails_initialization" do |app|
      app.middleware.insert_before Rack::Runtime, Rack::ServerTimingMiddleware
    end
  end
end
