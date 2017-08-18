require 'test_helper'
require 'active_support/notifications'
require 'rack'
# TODO(javierhonduco): test the proper addition of events
# with the same name
class IMServerTimingMiddlewareTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::IMServerTimingMiddleware::VERSION
  end

  def test_no_notifications
    status, headers, body = Rack::IMServerTimingMiddleware.new(FakeRack.new).call(nil)
    server_timing = headers['Server-Timing']

    refute_nil server_timing
    assert_empty server_timing
  end

  def test_multiple_notifications_simple
    status, headers, body = Rack::IMServerTimingMiddleware.new(SimpleMockedRack.new).call(nil)
    server_timing = headers['Server-Timing']
    assert_match /omg/, server_timing
    assert_match /lol/, server_timing
    assert_match /kawaii/, server_timing
  end

  def test_rack_runtime
    status, headers, body = Rack::IMServerTimingMiddleware.new(Rack::Runtime.new(SimpleMockedRack.new)).call(nil)
    server_timing = headers['Server-Timing']
    runtime = ('%.10f' % headers['X-Runtime']).to_f * 1000
    assert_match /runtime\.rack=#{runtime}/, server_timing
  end

end
