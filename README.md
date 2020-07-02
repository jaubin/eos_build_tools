# eos_build_tools
/e/ OS build script for your images. Check https://e.foundation

This script is intended to make it easier to build /e/OS images and to share your tweaks in the form of ```roomservice.xml``` files.

# How to build the image by yourself

The build will *not* work on Windows. For macOS I cannot guarantee. The build is known to work with Debian.

## Prerequisites

* Install Docker using the official Docker distribution. Documentation is <a href="https://docs.docker.com/engine/install/">there</a>.
* Add your own user to the Docker group, log out and log in.
* If you have set up a firewall with iptables rules, make sure your Docker containers can reach the Internet.
* You will need at least 120 GB of HDD space to to the build. A good internet connection is *strongly* advised.
* You will need at least 6 GB of free RAM.

## Using the script

To get the usage instructions of this script run command :

    build_eos_image.sh -h

To build an image :

    build_eos_image.sh -b <eOS_branch> -d <adb_device_name> [ -u <ota_url> ]

## Using a custom roomservice.xml

In order to use a custom ```roomservice.xml``` store it as file name ```roomservices/<eos_Branch>/<adb_device_name>``` under the scscript directory. A valid example is for device j5y17lte which is Samsung Galaxy J5 2017, built against /e/OS branch v0.9-oreo.

Then you're strongly encouraged to share your ```roomservice.xml``` by creating a pull request to this repo. This will make sure your build is reproducible on any host which is better for reliability, and will also help folks in case they need to maintain your image if you're not available to do so.

## Known issues with the build

You may face the following issues with the build :

* jackd may crash during the build. In that case check your sound card is not busy. If you're running in a graphical session run ```pulseaudio -k``` prior to launching the build.
* LLVM may also segfault. This one is random and I don't know how to fix it.
