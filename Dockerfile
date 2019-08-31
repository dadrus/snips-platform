#FROM raspbian/stretch
FROM arm32v7/debian:buster-slim

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y lsb-release dirmngr apt-utils apt-transport-https alsa-utils curl unzip python3-pip git tini
RUN bash -c 'echo "deb https://raspbian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list' && \
    apt-key adv --keyserver gpg.mozilla.org --recv-keys D4F50CDCA10A2849 && \
    apt-get update
RUN apt-get install -y snips-platform-voice snips-watch snips-analytics snips-template snips-skill-server && \
    pip3 install virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN usermod -aG snips-skills-admin root

COPY start-snips.sh /bin/start-snips.sh

EXPOSE 1883/tcp

ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["bash","/bin/start-snips.sh"]
