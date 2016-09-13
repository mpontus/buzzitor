require 'puma'
require 'sinatra/base';

class FakeHost
  def initialize(host="127.0.0.1", port=find_available_port(host), &block)
    @host = host
    @port = port
    @server_thread = nil
    configure &block
  end

  def configure(&block)
    app_class = Class.new(Sinatra::Base)
    app_class.class_exec &block
    @app = app_class.new!
    boot
  end

  def base_url
    "http://#{@host}:#{@port}"
  end

  def shutdown
    @server_thread.kill
    Timeout.timeout(5) { @server_thread.join(0.1) while responsive? }
    @server_thread = nil
  end

  private

  def boot
    shutdown if @server_thread
    @server_thread = Puma::Server.new(@app).tap do |s|
      s.add_tcp_listener(@host, @port)
    end.run
    Timeout.timeout(5) { @server_thread.join(0.1) until responsive? }
  end

  def find_available_port(host)
    server = TCPServer.new(host, 0)
    server.addr[1]
  ensure
    server.close if server
  end

  def responsive?
    TCPSocket.new(@host, @port).close
    return true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ECONNRESET
    return false
  end
end
