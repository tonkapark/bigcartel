require 'bigcartel/client'

module BigCartel
  class << self
    # Alias for BigCartel::Client.new
    #
    # @return [BigCartel::Client]
    def new(options={})
      BigCartel::Client.new(options)
    end

    # Delegate to Twitter::Client
    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end
