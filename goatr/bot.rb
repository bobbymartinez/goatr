module Goatr
  class Bot < SlackRubyBot::Bot
      help do
        title 'Goatr Rodeo'
        desc 'An incident response bot'

        command 'start incident <channel_name> (optional)' do
          desc 'Starts a new incident channel with the provided name, or a random name if none is provided'
        end

        command 'incident start <channel_name> (optional)' do
          desc 'Starts a new incident channel with the provided name, or a random name if none is provided'
        end

        command 'list incidents' do
            desc 'Lists the existing incidents'
        end

        command 'I am IC' do
            desc 'Marks yourself as Incident Commander'
        end

        command 'resolve incident' do
            desc 'Resolves an ongoing incident'
        end

        command 'what is an incident?' do
            desc 'Like the answer to life the universe and everything, but for incidents'
        end
      end
  end
end
