module Goatr
  module Commands
    class Incident < SlackRubyBot::Commands::Base
      @ops_slack_usergroup_handle = ENV['OPS_SLACK_USERGROUP_HANDLE']
      @slack_user = Slack::Web::Client.new(token:ENV['SLACK_USER_TOKEN'])
      @slack_client = Slack::Web::Client.new(token:ENV['SLACK_API_TOKEN'])

      match(/^goatr incident start (?<channel_name>\w*)$/i) do |client, data, match|
        client.say(channel: data.channel,
        text: "Making an Incident channel with the name #{match[:channel_name]}...")

        #create a channel with the first 21 characters of supplied name
        response = create_channel(match[:channel_name])
        new_channel_id = get_channel_id(response)
        client.say(channel: data.channel, text: "Incident channel #{match[:channel_name]} successfully created.")
        client.say(channel: data.channel, text: "Now starting the goat rodeo.  Inviting Ops to channel. data :#{data}, new_channel_id : #{new_channel_id}\n methods:#{client.methods}\n response from channel creation - #{response}")
        usergroup_user_ids = get_usergroup_users
        invite_users_to_channel(new_channel_id,usergroup_user_ids)
        client.say(channel: new_channel_id, text: "Welcome to the party, pal! \n https://cdn6.bigcommerce.com/s-r4b52/products/5258/images/20/esape__50973.1498690152.1280.1280.png")
      end

      match(/^goatr set ic (?<ic_name>\w*)$/i) do |client, data, match|
        set_channel_topic(data.channel,"Incident IC is #{match[:ic_name]}")
      end

      class << self
        def create_channel(channel_name)
          @slack_user.channels_create(name:channel_name[0..20])
        end

        def set_channel_topic(channel_id,topic_name)
          @slack_client.channels_setTopic(channel:channel_id,topic:topic_name)
        end

        def invite_users_to_channel(channel_id,user_ids)
          user_ids.each do |user_id|
            invite_user_to_channel(channel_id,user_id)
          end
        end

        def invite_user_to_channel(channel_id,user_id)
          @slack_user.channels_invite(channel:channel_id,user:user_id)
        end

        #can put this in use when the usergroup is dynamic.
        #for now slack user ids are hardcoded
        def get_usergroups
          @slack_user.usergroups_list
        end

        def get_usergroup_id(usergroup_handle,response)
          response['usergroups'].select{|usergroup| usergroup['handle'] == usergroup_handle}.first["id"]
        end

        #this method in the gem isn't working for some reason. I'll look into submitting
        #a patch at some point, for now, hardcoding invitation user ids.
        def get_usergroup_users
          ENV['OPS_SLACK_IDS'].split(",")
          #Slack::Web::Client.new(token:@slack_user_token).usergroups_users(usergroup_id)
        end

        def get_channel_id(response)
          response['channel']['id']
        end

        #To be implemented, input validation for legimitate slack channel names
        def incident_name

        end

      end

    end
  end
end
