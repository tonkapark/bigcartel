require 'bigcartel/client'

module BigCartel
  class << self
    # Alias for BigCartel::Client.new
    #
    # @return [BigCartel::Client]
    def new(options={})
      BigCartel::Client.new(options)
    end
  end
end
