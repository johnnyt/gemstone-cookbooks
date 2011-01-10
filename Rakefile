require 'rubygems'
require 'chef'
require 'json'

desc "Install needed gems and copy example files"
task :setup do
  puts "-- Checking for bundler"
  if %x[gem list] =~ /bundler/
    puts colorize("   bundler is already installed", :yellow)
  else
    puts colorize("   Installing bundler", :green)
    commands = []
    commands << "sudo gem install bundler --no-rdoc --no-ri"
    commands << "bundle install"
    system commands.join(" && ")
  end

  %w[ Vagrantfile roles/gemstone.json ].each do |filename|
    path = File.expand_path(File.join(File.dirname(__FILE__), filename))

    unless File.exists?(path)
      puts colorize("   Creating #{path}", :green)
      FileUtils.cp(path+".example", path)
    end
  end
end

desc "SSH into vagrant box as glass"
task :ssh do
  system "ssh -p2222 -XC glass@localhost"
end

desc "Open remote GemTools in local X11"
task :gemtools do
  system "ssh -YCn -p2222 glass@localhost gemtools &"
end

desc "Vagrant commands using bundle exec"
task :va, :cmd do |t, args|
  system "bundle exec vagrant #{args.cmd}"
end

COLORS = { 
           :none     => "0",
           :black    => "30",
           :red      => "31",
           :green    => "32",
           :yellow   => "33",
           :blue     => "34",
           :magenta  => "35",
           :cyan     => "36",
           :white    => "37"
        } 

ATTRIBUTES = {
          :none       => 0,
          :bright     => 1,
          :dim        => 2,
          :underscore => 4,
          :blink      => 5,
          :reverse    => 7,
          :hidden     => 8
        }

def colorize(message, color_name, attribute=nil)
  attribute = "#{attribute};" if attribute
  color = COLORS[color_name]
  "\e[#{attribute}#{color}m" + message + "\e[0m"
end
