require 'rubygems'
# require 'chef'
# require 'json'

def sudo
  "sudo" unless Gem.path.all? {|p| File.writable?(p) }
end

desc "Install needed gems and copy example files"
task :setup do
  puts colorize("-- Checking for RubyGems 1.3.6", :blue)

  md = %x[gem env].match(/(\d\.\d\.\d)/)
  version_string = md.captures.first

  if version_string.gsub(/\./, '').to_i >= 136
    puts colorize("   RubyGems #{version_string} is already installed", :yellow)
  else
    puts colorize("   Updating RubyGems - this may prompt for your password", :green)
    system "#{sudo} gem update --system"
  end

  puts colorize("-- Checking for Bundler", :blue)
  if %x[gem list] =~ /bundler/
    puts colorize("   Bundler is already installed", :yellow)
  else
    puts colorize("   Installing Bundler - this may prompt for your password", :green)
    system "#{sudo} gem install bundler --no-rdoc --no-ri"
  end

  puts colorize("-- Running bundle install", :blue)
  system "bundle install"

  puts colorize("-- Copying example files", :blue)
  %w[ Vagrantfile roles/gemstone.json ].each do |filename|
    path = File.expand_path(File.join(File.dirname(__FILE__), filename))

    if File.exists?(path)
      puts colorize("   Already exists: #{path}", :yellow)
    else
      puts colorize("   Creating #{path}", :green)
      FileUtils.cp(path+".example", path)
    end
  end

  note = <<-NOTE


-----[ NOTE ]-----
 Now be sure that you have put your SSH key in roles/gemstone.json
 This will allow you to easily ssh into the vagrant box as glass
 and have an environment setup with all the GemStone aliases and
 variables set.
   NOTE

  puts colorize(note, :blue)
end

desc "Open remote GemTools in local X11"
task :gemtools do
  system "ssh -YCn -p2222 glass@localhost gemtools &"
end

desc "SSH into vagrant box as glass with X forwarding enabled"
task :ssh do
  system "ssh -p2222 -XC glass@localhost"
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
