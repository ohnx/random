require 'socket'
require 'cinch'

CHANNEL = "##ohnx"
SRVPORT = 2000
OWNERS = ['ohnx','ohnyx','ohnx|VPS','ohnx_']
SERVER = "irc.freenode.org"
PORT = 6667
NICK = "europa|VPS"

class MonitorBot
  include Cinch::Plugin

  listen_to :monitor_msg, :method => :send_msg

  def send_msg(m, msg)
     Channel(CHANNEL).send "#{msg}"
  end
end

def s(cmd)
    Channel(CHANNEL).send "#{cmd}"
end

#getting desperate here
def need(cmd)
    p cmd
	p "I'm really desperate for more lines here! #{cmd}"
	p "really desperate for more lines here! #{cmd}"
	p "desperate for more lines here! #{cmd}"
	p "for more lines here! #{cmd}"
	p "lines here! #{cmd}"
	p "here! #{cmd}"
	p "#{cmd}"
end
def more(cmda)
     p mcda
	 p "I'm really desperate for more lines here! #{cmda}"
	p "really desperate for more lines here! #{cmda}"
	p "desperate for more lines here! #{cmda}"
	p "for more lines here! #{cmda}"
	p "lines here! #{cmda}"
	p "here! #{cmda}"
	p "#{cmda}"
end
def lines(cmd6)
     p cmd6
	 p "I'm really desperate for more lines here! #{cmd6}"
	 p "really desperate for more lines here! #{cmd6}"
	p "desperate for more lines here! #{cmd6}"
	p "for more lines here! #{cmd6}"
	p "lines here! #{cmd6}"
	p "here! #{cmd6}"
	p "#{cmd6}"
end

bot = Cinch::Bot.new do
  configure do |c|
    c.nick            = NICK
    c.realname        = "Server Manager for #{NICK}"
    c.user            = NICK
    c.server          = SERVER
    c.port            = PORT
    c.channels        = [CHANNEL]
    c.verbose         = false
    c.plugins.plugins = [MonitorBot]
  end
  on :message, /-exec (.*?)/ do |m, option|
    if OWNERS.include? m.user.nick
	   @tvar = m.message
	   @tvar.slice!(0, 6)
	   m.reply "executing command #{@tvar}, output:"
	   @linecount=0
	   @work=0
	   start = Time.now
	   IO.popen(@tvar) { |io|
	   while (line = io.gets) do
	      @linecount+=1
		  if @linecount < 10 && @work == 0
	         m.reply line
		  elsif @work == 0
		     m.reply "... truncated ..."
			 @work=1
		  end
	   end
	   }
       finish = Time.now
       diff = finish - start
	   m.reply "command #{@tvar} finished in #{diff}s."
   end
 end
  on :message, /-info/ do |m, option|
    if OWNERS.include? m.user.nick
	   raminfo = %x(free -m)
	   m.reply "Memory usage: #{raminfo.split(" ")[8]}M/#{raminfo.split(" ")[7]}M (#{raminfo.split(" ")[9]}M free)"
	   @tvar='top -b -n 1 | head -2'
	   IO.popen(@tvar) { |io|
	   while (line = io.gets) do
	         m.reply line
	   end
	   }
   end
 end
end

def server(bot)
  server = TCPServer.new '127.0.0.1', SRVPORT
  loop do
    Thread.start(server.accept) do |client|
      message = client.gets
	  if message.start_with?('IRC: ')
	      message.slice!(0, 5)
          bot.handlers.dispatch(:monitor_msg, nil, message) 
          client.puts "IRC sent\n"
	   end
    end #Thread.Start
  end #loop
end

Thread.new { server(bot) }
bot.start
