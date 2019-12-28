############################################################
# Dockerfile
############################################################

# Based on Debian
FROM docker.io/gameserver/steamcmd:latest

############################################################
# Installation
############################################################

# Setup
RUN echo "Installing ..." &&\
	# install server
	mkdir -p /app &&\
	steamcmd +login anonymous +force_install_dir /app +app_update 258550 +quit &&\
	# Grant permissions to root group
	chgrp -R 0 /app &&\
	chmod -R g=u /app

# Plugins / Modifications
RUN yum install -y curl unzip &&\
	curl --silent --location -o /tmp/umod.zip https://github.com/OxideMod/Oxide.Rust/releases/download/2.0.4385/Oxide.Rust-linux.zip &&\
	unzip -f -d /app /tmp/umod.zip

############################################################
# Execution
############################################################

# Expose
EXPOSE 28015/tcp

# User Id
USER 1001

# Execution
CMD "/app/RustDedicated" \
	"-batchmode" \
	+server.port 28015 \
	+server.level "Procedural Map" \
	+server.seed 3294 \
	+server.worldsize 4500 \
	+server.maxplayers 90 \
	+server.hostname "[Vanilla][EU]" \
	+server.description "Vanilla Rust" \
	+server.url "http://rust.com" \
	+server.headerimage "http://yourwebsite.com/serverimage.jpg" \
	+server.identity "server1" \
	+rcon.port 28016 \
	+rcon.password letmein \
	+rcon.web 1
