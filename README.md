# Yet another snips Docker image

Yes, it seems, there are a couple Docker images for [snips.ai](https://snips.ai/) in the wild.
Unfortunately I couldn't use any of these to just go my first steps with
snips by following the official [Quick Start Console](https://docs.snips.ai/getting-started/quick-start-console)
tutorial and then trying to deploy the results in a Docker container instead
of using `snips-sam` as e.g. described in [Quick Start Raspberry Pi](https://docs.snips.ai/getting-started/quick-start-raspberry-pi)
or [Raspiaudio MIC+ Snips tutorial](https://www.instructables.com/id/VOCAL-ASSISTANT-SnipsAi-Protects-Your-Privacy/). So this project was born.

## My Current HW-Setup

- [Raspberry Pi 3](https://www.raspberrypi.org/products/raspberry-pi-3-model-b-plus/)
- [Raspiaudio MIC+](https://www.raspiaudio.com/raspiaudio-aiy)

## Software-Stack

As discribed from the creator of Raspiaudio [here](https://www.instructables.com/id/VOCAL-ASSISTANT-SnipsAi-Protects-Your-Privacy/)
I've performed the following steps to install the required audio-driver
after plugging the hat on my Pi host:

```.bash
$ sudo wget -O mic mic.raspiaudio.com 
$ sudo bash mic
```

Reboot and test either using the test tool provided by raspiaudio

```.bash
$ sudo wget -O test test.raspiaudio.com
$ sudo bash test
```

After pushing the yellow button one should hear “front left, front right” then a recording will be played indicating that the mic and speakers are working well.

Or alternatively by using `aplay` and `arecord`. To list playback devices, run the following command:

```.bash
$ aplay -l
```

Which will produce something like this:

```
**** List of PLAYBACK Hardware Devices ****
card 0: sndrpigooglevoi [snd_rpi_googlevoicehat_soundcar], device 0: Google voiceHAT SoundCard HiFi voicehat-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

And to list the audio capture devices, run the command:

```.bash
$ arecord -l
```

Now you should see something like this:

```
**** List of CAPTURE Hardware Devices ****
card 0: sndrpigooglevoi [snd_rpi_googlevoicehat_soundcar], device 0: Google voiceHAT SoundCard HiFi voicehat-hifi-0 []
  Subdevices: 1/1
  Subdevice #0: subdevice #0
```

If you want to ensure, you can really record and playback execute and hit `CTRL-C` when you've done

```.bash
$ arecord -f cd out.wav
```

This will save a file, **out.wav** containing the recording. To check that both, the microphone and the speaker are working 
properly, run the following command

```.bash
$ aplay out.wav
```

It might be worth verifying that the installed playback and microphone devices can also be used in a docker container. For that
simply run e.g. a `rasbian/stretch` container, make the playback and the microphone devices and the corresponding configuration
available to it 

```.bash
$ docker run -ti --rm -v /etc/asound.conf --device /dev/snd raspbian/stretch /bin/bash
```

and repeat the tests described above in the container. You will have to install `alsa-utils` to be able to use `aplay` and `arecord`:


```.bash
$ apt-get update && apt-get install -y alsa-utils
```

The official snips [Raspberry Pi - Manual Setup](https://docs.snips.ai/articles/raspberrypi/manual-setup) article sais, one would require
to adjust the `asound.conf` configuration file to reference the appropriate playback and record devices. It seems the installation script
for Raspiaudio MIC+ (see above) already does it, so no specific settings are required.

Given the above prerequisites are in place, just follow the tutorial of your choice (e.g. one of the referenced above) to create your snips 
assistant. When ready download it from the snips console (in the below right corner of the web page you'll find a button named *Deploy Assistant*).
You'll receve a zip file, which you'll need to extract.

Time to build the Docker image. Just execute the `build.sh` script from this repository:

```.bash
$ ./build.sh
```

Take you a coffee, it will take a while. When ready, use the `run.sh` script to see your snips assistant in action. It will start the docker container
you've just built.

The `run.sh` script expects by default two directories to be present in the same folder:

* assistant - with your snips assistant
* log - to have system log files written to it.

So before running it, ensure you either adjust the path to your *assistant* directory (created, when you've extracted the zip file, downloaded from
the snips console) or move it to the directory `run.sh` is in and either create the *log* directory or delete the volume setting from the script if
you don't need the system logs.

Action time;)

```.bash
$ ./run.sh

INFO:snips_actions_templates_engine_lib: parsing snippets for app "/usr/share/snips/assistant/snippets/dadrus.My_Calculator"
INFO:snips_actions_templates_engine_lib: parsing snippets dir "/usr/share/snips/assistant/snippets/dadrus.My_Calculator/python3"
INFO:snips_actions_templates_engine_lib: parsed 6 snippets
Run setup.sh in ./dadrus.My_Calculator
Already using interpreter /usr/bin/python3
Using base prefix '/usr'
New python executable in /var/lib/snips/skills/dadrus.My_Calculator/venv/bin/python3
Also creating executable in /var/lib/snips/skills/dadrus.My_Calculator/venv/bin/python
Installing setuptools, pip, wheel...
done.
Looking in indexes: https://pypi.org/simple, https://www.piwheels.org/simple
Collecting hermes-python>=0.2 (from -r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/2b/44/072e233a0eef525a0dff68bd0b8f7b7a6140140468ad59506ec40b0ca505/hermes_python-0.7.0-cp35-cp35m-linux_armv7l.whl
Collecting future (from hermes-python>=0.2->-r requirements.txt (line 2))
  Using cached https://www.piwheels.org/simple/future/future-0.17.1-py3-none-any.whl
Collecting enum34 (from hermes-python>=0.2->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/af/42/cb9355df32c69b553e72a2e28daee25d1611d2c0d9c272aa1d34204205b2/enum34-1.1.6-py3-none-any.whl
Collecting six (from hermes-python>=0.2->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/73/fb/00a976f728d0d1fecfe898238ce23f502a721c0ac0ecfedb80e0d88c64e9/six-1.12.0-py2.py3-none-any.whl
Collecting typing (from hermes-python>=0.2->-r requirements.txt (line 2))
  Using cached https://files.pythonhosted.org/packages/28/b8/a1d6b7cf322f91305bcb5e7d8f6c3028954d1e3e716cddc1cdce2ac63247/typing-3.7.4-py3-none-any.whl
Installing collected packages: future, enum34, six, typing, hermes-python
Successfully installed enum34-1.1.6 future-0.17.1 hermes-python-0.7.0 six-1.12.0 typing-3.7.4
INFO:snips_analytics_hermes: The analytics service is temporarily disabled
INFO:snips_nlu_hermes: loading nlu engine "/usr/share/snips/assistant/nlu_engine"
INFO:snips_dialogue_hermes: Loading the configuration file

...

INFO:snips_nlu_lib::slot_filler::crf_slot_filler                : Loading CRF slot filler ("/usr/share/snips/assistant/nlu_engine/probabilistic_intent_parser/slot_filler_5") ...
INFO:snips_nlu_lib::slot_filler::crf_slot_filler                : CRF slot filler loaded
INFO:snips_nlu_hermes                                           : model loaded in 2010 ms
INFO:snips_hotword::server       : Discovered audio_server server/mqtt, starting hotword listener
INFO:snips_hotword::server       : Connecting using MQTT site-id server
INFO:snips_hotword_lib::audio    : Audio thread for server started
INFO:snips_hotword_lib::audio    : Net and VAD thread for site server started (vad inhibitor: true, vad messages: false
INFO:snips_hotword_lib           : Detector "detector.hey_snips.server", sensitivity: 0.5, threshold 0.787
INFO:snips_hotword_lib           : detector.hey_snips.server thread started
```

Now you can talk to your assistant.

## TODOs

* Support satellite setups
* Strip down the Docker image. It is 864MB in size.
* Write documentation about the Docker image expectations, like expected volumes, exposed ports, etc
* Deploy to Docker Hub



