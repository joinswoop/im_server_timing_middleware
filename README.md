# IMIMServerTimingMiddleware

Forked from [im_server_timing_middleware](https://github.com/javierhonduco/im_server_timing_middleware) with the following changes:

  * correctly handles `ms` values (used by `ActiveSupport::Notifications`)
  * automatically inserts itself in the middlware stack before `Rack::Runtime` via a railtie
  * adds the `X-Runtime` value as `runtime.rack`
  * adds a `middleware.rack` measurement which is the difference between `runtime.rack` and `endpoint_run.grape`
