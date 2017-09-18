module Goatr
  module Commands
    class Help < SlackRubyBot::Commands::Base
      command 'help' do |client, data, _match|
        client.say(channel: data.channel,
        text: %{ Are you trying to start an incident?  Try "goatr start incident <incident name less than 22 characters>"
That should get you where you need to be.
See https://github.com/bobbymartinez/goatr for more information on commands.})
      end
    end
  end
end
