# eos_j5y17lte
/e/ OS build scripts for Samsung Galaxy J5 2017 LTE. Check https://e.foundation

# DISCLAIMER

These script build an image of /e/OS for Galaxy J5 2017 LTE using LineageOS 15.1 (Android Oreo). However I could *not* test the image as of now because I cannot afford risking to brick my phone. So use it at your own risk. However I'd be very interested in getting feedbacks about it.

# How to build the image by yourself

The build will *not* work on Windows. For macOS I cannot guarantee. The build is known to work with Debian.

## Prerequisites

* Install Docker using the official Docker distribution. Documentation is <a href="https://docs.docker.com/engine/install/">there</a>.
* Add your own user to the Docker group, log out and log in.
* If you have set up a firewall with iptables rules, make sure your Docker containers can reach the Internet.
* You will need at least 120 GB of HDD space to to the build. A good internet connection is *strongly* advised.
* You will need at least 6 GB of free RAM.

## Running the build

Run command :

    ./build_image_with_local_manifest.sh <eOS_branch> j5y17lte

As of now we only tested with branch ```v0.9-oreo``` and it won't work with any other branch unless you update the content of file ```srv/e/local_manifests/roomservice.xml```. However the sh scripts themselves are reusable for any device so that you don't have to type by yourself the rather cumbersome Docker commands.

## Known issues with the build

You may face the following issues with the build :

* jackd may crash during the build. In that case check your sound card is not busy. If you're running in a graphical session run ```pulseaudio -k``` prior to launching the build.
* LLVM may also segfault. This one is random and I don't know how to fix it.
