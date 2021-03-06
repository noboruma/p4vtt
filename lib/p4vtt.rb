require 'tty-prompt'
prompt = TTY::Prompt.new
require 'tty-spinner'
require 'colorize'

@user   = "#{ENV["USER"]}"
$tmpdir = "/tmp/p4v"
$lastAction = ''

require "#{File.dirname(__FILE__)}/p4desc"
require "#{File.dirname(__FILE__)}/p4vpen"
require "#{File.dirname(__FILE__)}/p4vsub"

trap("SIGINT") { throw :ctrl_c }

def clearScreen()
    puts "\e[H\e[2J"
end

clearScreen
newUser = prompt.ask("username:", default: @user)
@user = newUser
while true
    catch :ctrl_c do begin
        clearScreen
        unless $lastAction.empty?
            puts $lastAction
        end

        choice = prompt.select("What kind of Changelist to access?", %w(Pending Submitted), cycle: true)
        case choice
        when "Pending"
          Pending.main(prompt, @user)
        when "Submitted"
          Submitted.main(prompt, @user)
        end
    rescue TTY::Reader::InputInterrupt
        clearScreen
    rescue Exception => e
        $lastAction=e.inspect
    end
    end
end
