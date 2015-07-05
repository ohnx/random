#!/usr/bin/perl
	use warnings;
	package MyBot;
	use base qw( Bot::BasicBot );

	# the 'said' callback gets called when someone says something in earshot of the bot.
	sub said {
		my ($self, $message) = @_;
		if ((index($message->{body}, "crystal ball") != -1)&&(index($message->{body}, "?") != -1)&&(index($message->{body}, "ok?") == -1)) {
			#random number to reply
			$num=int(rand(5));
			if ($num==0) {return "In my expert opinion, yes.";}
			elsif ($num == 1) {return "Certainly, the answer is yes.";}
			elsif ($num == 2) {return "It appears as if the answer is no.";}
			elsif ($num == 3) {return "Hmmm, that is a good question. I cannot say so right now, ask me again later.";}
			elsif ($num == 4) {return "In my many years of crystal ball gazing, I have never been so sure not.";}
		}
		if ((index($message->{body}, "crystal ball") != -1)&&(index($message->{body}, "ok?") != -1)) {
			return "ok."
		}
		if ((index($message->{body}, "crystal ball") != -1)&&(index($message->{body}, "help") != -1)) {
			return "Ask me a question, and I shall reply."
		}
	}
	sub chanjoin {
		#greet people
		my ($self, $message) = @_;
		return "Hello, $message->{who}. I like camels.\n";
	}
		
	# Create an instance of the bot and start it running. Connect to server.
	MyBot->new(
		server => 'irc.freenode.net',
		channels => [ '##ohnx' ],
		nick => 'crystalbot',
	)->run();
