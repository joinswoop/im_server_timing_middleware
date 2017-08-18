module IMServerTimingMiddleware
  class Railtie < Rails::Railtie
    initializer "im_server_timing_middleware.configure_rails_initialization" do |app|
      app.middleware.insert_before Rack::Runtime, Rack::IMServerTimingMiddleware
    end
  end
end
