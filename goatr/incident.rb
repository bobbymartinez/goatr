module Goatr
  class Incident < Hashie::Mash
    class NotFoundError < StandardError; end
    @@storage = Goatr::Storage::Incident.new
    attr_accessor :id,:status,:slack_commander_name,:slack_commander_id,
                  :start_time,:stop_time,:slack_channel_name,:slack_channel_id

    def initialize(params)
      raise "MustSpecifyParameters" unless params
      @id = params["id"]
      @status = params["status"]
      @slack_commander_name = params["slack_commander_name"]
      @slack_commander_id = params["slack_commander_id"]
      @start_time = params["start_time"]
      @end_time = params["end_time"]
      @slack_channel_name = params["slack_channel_name"]
      @slack_channel_id = params["slack_channel_id"]
    end

    def self.create
      incident_info = @@storage.new_incident
      raise "CouldNotCreateIncident" unless incident_info
      self.new(incident_info)
    end

    def self.find(id)
      incident_info = @@storage.get_incident(id)
      return nil unless (incident_info && !incident_info.empty?)
      self.new(incident_info)
    end

    def self.find_incident_by_channel_id(channel_id)
      incident_id = @@storage.get_incident_id_by_channel_id(channel_id)
      self.find(incident_id)
    end

    def save
      raise "CouldNotSaveWithoutId" unless @id
      incident_info = @@storage.save_incident(@id,{"id" => @id,
                                    "status" => @status,
                                    "slack_commander_name" => @slack_commander_name,
                                    "slack_commander_id" => @slack_commander_id,
                                    "start_time" => @start_time,
                                    "end_time" => @end_time,
                                    "slack_channel_name" => @slack_channel_name,
                                    "slack_channel_id" => @slack_channel_id})
    end

    def map_channel(channel_id)
      @@storage.map_channel_to_incident(channel_id,@id)
    end

  end
end
