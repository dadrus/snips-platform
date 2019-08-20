#!/bin/bash
set -e

# goto skill directory
cd /var/lib/snips/skills

# start with a clear skill directory
rm -rf *

# deploy apps (skills). See: https://snips.gitbook.io/documentation/console/deploying-your-skills
snips-template render

# download required skills from git
for url in $(awk '$1=="url:" {print $2}' /usr/share/snips/assistant/Snipsfile.yaml); do
  git clone $url
done

# be shure we are still in the skill directory
cd /var/lib/snips/skills

# run setup.sh for each skill.
find . -maxdepth 1 -type d -print0 | while IFS= read -r -d '' dir; do
  cd "$dir" 
  if [ -f setup.sh ]; then
    echo "Run setup.sh in "$dir
    #run the scrips always with bash
    bash ./setup.sh
  fi
  cd /var/lib/snips/skills
done

# skill deployment is done

# go back to root directory
cd /

# start own mqtt service.
mosquitto -d

# start Snips analytics service
snips-analytics &
snips_analytics_pid=$!

# start Snips' Automatic Speech Recognition service
snips-asr &
snips_asr_pid=$!

# start Snips-dialogue service
snips-dialogue &
snips_dialogue_pid=$!

# start Snips hotword service
snips-hotword &
snips_hotword_pid=$!

# start Snips Natural Language Understanding service
snips-nlu &
snips_nlu_pid=$!

# start Snips Skill service
snips-skill-server &
snips_skill_server_pid=$!

# start Snips TTS service
snips-tts &
snips_tts_pid=$!

#start the snips audio server 
snips-audio-server --hijack localhost:64321 &
snips_audio_server_pid=$!

wait "$snips_analytics_pid" "$snips_asr_pid" "$snips_dialogue_pid" "$snips_hotword_pid" "$snips_nlu_pid" "$snips_skill_server_pid" "$snips_audio_server_pid"
