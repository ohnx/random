require 'socket'
require 'cinch'

CHANNEL = "##ohnx"
LISTENING_PORT = 2000

class MonitorBot
  include Cinch::Plugin

  listen_to :monitor_msg, :method => :send_msg

  def send_msg(m, msg)
     Channel(MY_CHANNEL).send "#{msg}"
  end

end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = "ohnxVPShelper"
    c.realname        = "Door Bot"
    c.user            = "myuser"
    c.server          = "irc.freenode.org"
    c.port            = 6667
    c.channels        = [CHANNEL]
    c.verbose         = false
    c.plugins.plugins = [MonitorBot]
  end
end

def server(bot)
  server = TCPServer.new '127.0.0.1', MY_LISTENING_PORT
  loop do
    Thread.start(server.accept) do |client|
      message = client.gets
	  if message.start_with?('IRC: ')
	      message.slice!(0, 4)
          bot.handlers.dispatch(:monitor_msg, nil, message) 
          client.puts "IRC sent\n"
	  elsif message.start_with?('SYS: ')
	      message.slice!(0, 4)
          spawn message
          client.puts "System sent\n"
	  end
	  client.close
    end #Thread.Start
  end #loop
end

Thread.new { server(bot) }
bot.start
