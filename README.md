# Chef cookbooks for GemStone

Most of the commands here have been taken from:

* [http://programminggems.wordpress.com/2010/01/12/slicehost-2](http://programminggems.wordpress.com/2010/01/12/slicehost-2)
* [http://onsmalltalk.com/2010-10-30-installing-a-gemstone-seaside-server-on-ubuntu-10.10)](http://onsmalltalk.com/2010-10-30-installing-a-gemstone-seaside-server-on-ubuntu-10.10)
* [http://onsmalltalk.com/2010-10-23-faster-remote-gemstone](http://onsmalltalk.com/2010-10-23-faster-remote-gemstone)

## Vagrant Install Instructions

First - you need to have the following installed on your system:

* Ruby
* [Vagrant](http://vagrantup.com/)
* A Lucid 64bit vagrant box named lucid64 ( vagrant box add base http://files.vagrantup.com/lucid64.box )

Clone the project if you haven't already:

**<pre>
git clone https://github.com/johnnyt/gemstone-cookbooks.git
</pre>**


Then from the project root run the following command. This will try to update your RubyGems, install and
run [Bundler](http://gembundler.com/), and copy example files. 
**<pre>
rake setup
</pre>**

Now open up roles/gemstone.rb and copy your *public* ssh key (probably ~/.ssh/id_rsa.pub or ~/.ssh/id_dsa.up) into the file - about half way down.

You can check out Vagrantfile for information about the virtual-box. The code is mainly in the cookbooks/gemstone/recipes/ directory.
Now if rake setup ran well - run the following to setup your vagrant box (this also reboots the box for some GemStone settings).
This will take a while - you'll see the progress of the Vagrant and Chef as its running.
**<pre>
rake va[up] && rake va[reload]
</pre>**


Check out Rakefile (or just run rake -T) to check out the rake tasks
You can check out Vagrantfile for information about the virtual-box. The code is mainly in the cookbooks/gemstone/recipes/ directory.

Once the setup is all done - you should be able to pull up [http://localhost:8888/](http://localhost:8888/) and see the default SeaSide site.
You can also run this to open up an X11 session:
**<pre>
rake gemtools
</pre>**

To ssh into the Vagrant box as glass - as soon as you get your prompt you can open up a [screen](http://www.gnu.org/software/screen/)
session just by typing 's' - an alias for start_screen which starts a new session if none is found, or attaches to a shared session if one is already running.
**<pre>
rake ssh
</pre>**

Here are the current rake commands (found in Rakefile):

**<pre>
rake gemtools  # Open remote GemTools in local X11
rake setup     # Install needed gems and copy example files
rake ssh       # SSH into vagrant box as glass
rake va[cmd]   # Vagrant commands using bundle exec
</pre>**

Todo:

* IPTables


(MIT License) - Copyright (c) 2010 JohnnyT

