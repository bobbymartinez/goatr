$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'goatr'
require 'web'

Thread.new do
  begin
    Goatr::Bot.run
  rescue Exception => e
    STDERR.puts "ERROR: #{e}"
    STDERR.puts e.backtrace
    raise e
  end
end

run Goatr::Web
