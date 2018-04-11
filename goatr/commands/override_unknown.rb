module Goatr
  module Commands
    class Unknown < SlackRubyBot::Commands::Unknown
      #I have no idea why but with this puts statement here the Unkown class override actually works
      #without it, every command gets matched as Unknown, even commands we've defined and have worked previously.
      #¯\_(ツ)_/¯
      puts "name : #{self.name} superclass: #{self.superclass.name}"
      match(/^(?<bot>\S*)[\s]*(?<expression>.*)$/)

      def self.call(client, data, _match)
        client.say(channel: data.channel,
        text: %{ I'm sorry, I don't recognize that command.  \n\nAre you trying to start an incident?  Try "goatr start incident <incident name less than 22 characters>"
That should get you where you need to be.
See https://github.com/bobbymartinez/goatr for more information on commands.})
      end
    end

  end
end
