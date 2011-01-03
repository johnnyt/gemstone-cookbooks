# Chef cookbooks for GemStone

Most of the commands here have been taken from:

* http://programminggems.wordpress.com/2010/01/12/slicehost-2
* http://onsmalltalk.com/2010-10-30-installing-a-gemstone-seaside-server-on-ubuntu-10.10
* http://onsmalltalk.com/2010-10-23-faster-remote-gemstone

## Vagrant Install Instructions

First - you need to have the following installed on your system:

* Ruby
* [Vagrant](http://vagrantup.com/)
* A Lucid 64bit vagrant box named lucid64 ( vagrant box add base http://files.vagrantup.com/lucid64.box )

Then from the project root run:

<pre>
bundle install
cp Vagrantfile.example Vagrantfile
cp roles/gemstone.json.example roles/gemstone.json
</pre>

Open roles/gemstone.json and put in your PUBLIC ssh key.

Now run the following to setup your vagrant box (this also reboots the box for some GemStone settings)

<pre>
vagrant up && vagrant reload
</pre>

Now ssh in and run:

<pre>
startstone -N && sudo /etc/init.d/gs_fastcgi start
</pre>

Now you should be able to pull up the SeaSide site in a browser.

Todo:

* IPTables


(MIT License) - Copyright (c) 2010 JohnnyT
