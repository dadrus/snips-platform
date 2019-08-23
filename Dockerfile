FROM arm32v7/debian:stretch-slim

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y dirmngr apt-utils apt-transport-https alsa-utils curl unzip python3-pip git && \
    bash -c  'echo "deb https://debian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list' && \
    apt-key adv --keyserver pgp.mit.edu --recv-keys F727C778CCB0A455 && \
    apt-get update && \
    apt-get install -y snips-platform-voice snips-tts snips-watch snips-analytics snips-template snips-skill-server && \
    pip3 install virtualenv && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
RUN usermod -aG snips-skills-admin root

COPY start-snips.sh /bin/start-snips.sh

EXPOSE 1883/tcp


CMD ["bash","/bin/start-snips.sh"]
