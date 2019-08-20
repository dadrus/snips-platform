# Yet another snips Docker image

Yes, it seems, there are a couple Docker images for [snips.ai](https://snips.ai/) in the wild.
Unfortunately I couldn't use any of these to just go my first steps with
snips. So this project was born.

## My Current HW-Setup

- [Raspberry Pi 3](https://www.amazon.com/Raspberry-1373331-Pi-Modell-Mainboard/dp/B07BDR5PDW/ref=sr_1_3?__mk_de_DE=%C3%85M%C3%85%C5%BD%C3%95%C3%91&crid=1FJGK88YIA93Z&keywords=raspberry+pi+3&qid=1566326809&s=gateway&sprefix=raspberr%2Caps%2C175&sr=8-3)
- [Raspiaudio MIC+](https://www.raspiaudio.com/raspiaudio-aiy)

## Software-Stack

As discribed from the creator of Raspiaudio [here](https://www.instructables.com/id/VOCAL-ASSISTANT-SnipsAi-Protects-Your-Privacy/)
I've performed the following steps to install the required audio-driver
after plugging the hat on my Pi host:

```.bash
$ sudo wget -O mic mic.raspiaudio.com 
$ sudo bash mic
```

Reboot and test

```.bash
$ sudo wget -O test test.raspiaudio.com
$ sudo bash test
```

After pushing the yellow button one should hear “front left, front right” then a recording will be played indicating that the mic and speakers are working well.



Update will follow.


