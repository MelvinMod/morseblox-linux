# morseblox-linux
Type to convert English into Morse code while interacting with others on Sober (Roblox)

# WARNING
this is using the legacy method of morse code, legacy means old (2012) original way, there is one [game](https://www.roblox.com/games/72977384690398/Morse-Code-Trainer) that supports only newer morse code method instead of old (legacy) one, so, don't expect this script to work in that game

# Reasons why I did that
https://youtu.be/xuNdSNuraeQ

# Tutorial
1. install `xdotool` using your package manager (on Arch Linux and EndeavourOS it is `pacman`)
2. unblock `.sh` file
```bash
sudo chmod +x morseblox.sh
```
3. type
```bash
./morseblox.sh "your message is in quotes"
```
4. open Sober and wait 3 seconds

# Video tutorial
https://youtu.be/7q06_t61xE4

# Settings
default settings is:
```sh
DOT_HOLD=0.26
DASH_HOLD=0.33
BETWEEN_SYMBOLS=0.23
LETTER_FREEZE=1.05
WORD_PAUSE=1.3
```
