FROM arm32v7/debian:buster-slim

RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get dist-upgrade -y && \
    apt-get install -y tzdata dirmngr apt-transport-https alsa-utils curl unzip python3-pip python3-pip git && \
    bash -c 'echo "deb https://raspbian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list' && \
    apt-key adv --keyserver gpg.mozilla.org --recv-keys D4F50CDCA10A2849 && \
    apt-get update && \
    apt-get install -y snips-platform-voice snips-template snips-skill-server snips-watch snips-analytics && \
    pip3 install virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN usermod -aG snips-skills-admin root

COPY start-snips.sh /bin/start-snips.sh

EXPOSE 1883/tcp


CMD ["bash","/bin/start-snips.sh"]
