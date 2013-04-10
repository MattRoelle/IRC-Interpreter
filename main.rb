require 'socket'

IRC = TCPSocket.open('irc.freenode.net',6667)
IRC.send "USER meh mehh mehh :mehhhh mehhh\r\n", 0
IRC.send "NICK R0000By\r\n", 0
IRC.send "JOIN ##the_basement\r\n", 0

until IRC.eof? do
  raw = IRC.gets
  if raw.match(/^PING :(.*)$/)
    IRC.send "PONG #{$~[1]}\r\n", 0
  else
    code = nil
    message = raw.split(":").pop
    if message[0] == '`'
      code = message[1..-1]
      unless code.include? '%x' or code.include? 'exec'
        output = %x(echo "#{code}" | ruby)
        if output.split("\n").length <= 4
          output.each_line do |l|
            IRC.send "PRIVMSG ##the_basement :#{l}\r\n", 0
          end
        end
      end
    end
  end
end
