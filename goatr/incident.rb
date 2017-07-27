module Goatr
  class Incident < Hashie::Mash
    class NotFoundError < StandardError; end

    attr_accessor :id

    def initialize(id)
      @id = id
    end
    

    def self.create

    end

    def self.find(id)
      storage = Goatr::Storage::Incident.new
      u = storage.get_incident(id)
      return nil unless (u && !u.empty?)
      self.new
    end

  end
end
