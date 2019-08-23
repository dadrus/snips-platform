#!/bin/bash
docker run --name snips \
  -v ${PWD}/snips.toml:/etc/snips.toml \
  -v ${PWD}/assistant:/usr/share/snips/assistant \
  -v ${PWD}/log:/var/log \
  -v ${PWD}/asound.conf:/etc/asound.conf \
  --device /dev/snd \
  -v /etc/timezone:/etc/timezone:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -p 1883:1883 \
  --privileged \
  --log-driver none \
  dadrus/snips-docker
