FROM raspbian/stretch 

ENV TZ=Europe/Amsterdam

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y apt-utils

RUN apt-get dist-upgrade -y

RUN apt-get install -y dirmngr apt-transport-https alsa-utils curl unzip python3-pip python3-pip git

RUN bash -c 'echo "deb https://raspbian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list' && \
    apt-key adv --keyserver gpg.mozilla.org --recv-keys D4F50CDCA10A2849 && \
    apt-get update && \
    apt-get install -y snips-platform-voice snips-template snips-skill-server snips-watch snips-analytics

RUN pip3 install virtualenv
    
RUN usermod -aG snips-skills-admin root

COPY start-snips.sh /bin/start-snips.sh

EXPOSE 1883/tcp


CMD ["bash","/bin/start-snips.sh"]
