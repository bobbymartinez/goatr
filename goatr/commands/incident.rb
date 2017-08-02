require 'goatr/storage/incident'
require 'goatr/incident'

module Goatr
  module Commands
    class Incident < SlackRubyBot::Commands::Base
      @@responders_usergroup_handle = ENV['RESPONDERS_SLACK_USERGROUP_HANDLE']
      @@responsers_usergroup_id = ENV['RESPONDERS_SLACK_USERGROUP_ID']
      @@incident_bots_slack_ids = ENV['BOT_SLACK_IDS']
      @@slack_user = Slack::Web::Client.new(token:ENV['SLACK_USER_TOKEN'])
      @@slack_client = Slack::Web::Client.new(token:ENV['SLACK_API_TOKEN'])
      @@authorized_user_ids = ENV['AUTHORIZED_USER_IDS']
      @@storage = Goatr::Storage::Incident.new

      match(/^goatr start incident (?<channel_name>\w*)$/i) do |client, data, match|
        raise "User #{data['user']} not authorized." unless is_authorized?(data['user'])
        client.say(channel: data.channel,
        text: " <!subteam^#{@@responsers_usergroup_id}|#{@@responders_usergroup_handle}> Making an Incident channel:  #{match[:channel_name]}...")

        #create a channel with the first 21 characters of supplied name
        response = create_channel(match[:channel_name])
        new_channel_id = get_channel_id(response)
        incident = create_new_incident(match[:channel_name],new_channel_id)
        client.say(channel: data.channel, text: "Incident channel <##{new_channel_id}|#{match[:channel_name]}> successfully created.")
        client.say(channel: data.channel, text: "Now starting the goat rodeo. Inviting Ops to ##{match[:channel_name]}")
        invite_responders_to_channel(new_channel_id)
        post_to_channel(new_channel_id,"Welcome to the party, pal! \n https://cdn3.bigcommerce.com/s-d2bmn/images/stencil/1280x1280/products/3884/6/escape__01810.1500921070.png\n\n\nIncident Commander, set yourself with command \"goatr I am IC\"")
      end

      match(/^goatr list incidents$/i) do |client, data, match|
        client.say(channel: data.channel, text:"#{get_incident_list}")
      end

      #need to make this set the incident commander data in the incident data
      #for no it just adjusts the channel title.  Need to add a channel_id -> incident id mapping
      #to dynamically lookup incident ID by channel id to see which incident this applies to.
      match(/^goatr I am IC$/i) do |client, data, match|
        raise "User #{data['user']} not authorized." unless is_authorized?(data['user'])
        user_info = get_slack_user_info(data['user'])
        set_channel_topic(data.channel,"Incident IC is #{user_info['user']['profile']['real_name']}")
        incident = Goatr::Incident.find_incident_by_channel_id(data.channel)
        incident.slack_commander_name = user_info['user']['profile']['real_name']
        incident.slack_commander_id = user_info['user']['id']
        incident.save
        incident
      end

      match(/^goatr resolve incident$/i) do |client, data, match|
        raise "User #{data['user']} not authorized." unless is_authorized?(data['user'])
        begin
          incident = Goatr::Incident.find_incident_by_channel_id(data.channel)
          incident.status = "resolved"
          incident.end_time = Time.now.to_i
          incident.save
          client.say(channel: data.channel, text:"Resolved incident #{incident.id} for channel #{incident.slack_channel_name}")
        rescue => e
          puts "#{e.to_json}"
        end

      end

      match(/^goatr test$/i) do |client, data, match|
        raise "User #{data['user']} not authorized." unless is_authorized?(data['user'])
        # user_info = get_user_info(data["user"])
        # puts "#{user_info['user']}"
        # puts "#{user_info['user']['id']}"
        puts @@storage.get_incidents.class
        puts @@storage.get_incidents.to_s
      end

      match(/^goatr what is an incident?$/i) do |client, data, match|
        begin
          client.say(channel: data.channel, text:"It's when something bA-A-A-A-A-A-A-d happens because Mitch broke something.")
        rescue => e
          puts "#{e.to_json}"
        end

      end

      class << self
        #submits with the first 21 characters since that is the max limit for slack name
        #will refactor to do proper validation later

        def create_new_incident(channel_name,channel_id)
          incident = Goatr::Incident.create
          incident.slack_channel_name = channel_name
          incident.slack_channel_id = channel_id
          incident.status = "active"
          incident.start_time = Time.now.to_i
          incident.save
          incident.map_channel(channel_id)
          incident
        end

        def create_channel(channel_name)
          @@slack_user.channels_create(name:channel_name[0..20])
        end

        def set_incident_commander(user_id,user_name)
          puts "#{user_info}"
        end

        def set_channel_topic(channel_id,topic_name)
          @@slack_client.channels_setTopic(channel:channel_id,topic:topic_name)
        end

        def post_to_channel(channel_id,message)
          @@slack_client.chat_postMessage(channel:channel_id,text:message,as_user:true)
        end

        def get_slack_user_info(user_id)
          user_info = get_user_info(user_id)
          return nil unless (user_info && !user_info.empty?)
          user_info
        end

        def get_incident_list
          incidents = Goatr::Incident.all
          str_output = []
          incidents.each do |incident|
            str_output << "#{incident.id} - ##{incident.slack_channel_name} - Status: #{incident.status}"
          end
          str_output.join("\n")
        end

        def get_user_info(user_id)
          begin
            @@slack_client.users_info(user:user_id)
          rescue
            nil
          end
        end

        def get_usergroups
          begin
            response = @@slack_user.usergroups_list
          rescue
            nil
          end
          if response["ok"]
            response['usergroups']
          else
            nil
          end
        end

        def get_responders_usergroup_id
          ENV['RESPONDERS_SLACK_USERGROUP_ID']
          # can uncomment the bottom code if we ever want to make this dynamic based on
          # usergroup id, for now it's faster to load from ENV var since we know which UserGroup
          # we want to invite beforehand
          # usergroups = get_usergroups
          # return nil unless (usergroups && !usergroups.empty?)
          # ug = usergroups.select{|usergroup| usergroup['handle'] == @@responders_usergroup_handle}.first
          # return nil unless (ug && !ug.empty?)
          # ug['id']
        end

        def get_responder_ids
          responders_usergroup_id = get_responders_usergroup_id
          return nil unless responders_usergroup_id
          begin
            response = @@slack_user.usergroups_users_list(usergroup:responders_usergroup_id)
          rescue => e
            nil
          end
          return nil unless response and !response.empty?
          #returns a native ruby Array instead of Hashie::Array
          response.users.map{|user_id| user_id}
        end

        def invite_responders_to_channel(channel_id)
          responder_ids = get_responder_ids
          return nil unless responder_ids and !responder_ids.empty?
          bot_slack_ids = get_bot_slack_ids
          invite_users_to_channel(channel_id,(responder_ids + bot_slack_ids))
        end

        def invite_users_to_channel(channel_id,user_ids)
          user_ids.each do |user_id|
            invite_user_to_channel(channel_id,user_id)
          end
        end

        def invite_user_to_channel(channel_id,user_id)
          @@slack_user.channels_invite(channel:channel_id,user:user_id)
        end

        def get_bot_slack_ids
          @@incident_bots_slack_ids.split(",")
        end

        def get_usergroup_id(usergroup_handle,response)
          response['usergroups'].select{|usergroup| usergroup['handle'] == usergroup_handle}.first['id']
        end

        def get_channel_id(response)
          response['channel']['id']
        end

        def is_authorized?(user_id)
          @@authorized_user_ids.include? user_id
        end

        #To be implemented, input validation for legimitate slack channel names
        def incident_name

        end

      end

    end
  end
end
