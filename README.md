## Spotify Connect integration for Airplay Multiroom Streaming

### tl;dr
```
- Enables you to play Spotify music on all your airplay devices in sync while controlling it from your Spotify client of choice, e.g. your iPhone Spotify app.
- Needs a Raspberry Pi, Docker, jq, git (:)) and a Premium Spotify account including Web API tokens
- Jump to sections "IV. Preperation" and "V. Let's go" to start
```

### I. About - why do I need this
- this repository makes use of other awesome repos such as forked-daapd (https://github.com/ejurgensen/forked-daapd) and librespot/raspotify (https://github.com/dtcooper/raspotify) -- **full credit to those two contributors** -- , combining them in one easy to use docker container including a small command line based control script
- syncs all airplay devices across your home, from old-generation Airport Express, Apple TV, 3rd party airplay speakers to newest generation airplay 2 protocol devices such as Apple TV 4 and others
- control song selection and other functions directly from your spotify client of choice, e.g. your iPhone spotify app
- let's you integrate this whole project in a bigger home automation project by starting / stopping spotify music on all your airplay devices just with one command line via a webserver or voice control (refer to bash script controlspotify), example integration in a home automation setup.

### II. What - how does it work
- forked-daapd does all the heavy lifting here by using the airplay protocol to stream and sync mulitple speakers, however the spotify integration of forked-daapd is based on a old framework which lacks Spotify Connect for controlling your sound across multiple devices
- at this point, raspotify (which is essentially an installation client for the underlying librespot framework https://github.com/librespot-org/librespot) comes in which offers Spotify Connect support while running a headless spotify client 
- I have taken the audio output of librespot, piping it via FIFO in the forked-daapd application
- for uncomplicated selection of all your airplay devices as well as starting and stopping of spotify playback directly from command line, I have written a small bash wrapper script by accessing Spotify's Web Api 

### III. Dependencies - what you need to install
- you need a **Raspberry Pi** with a Linux-based operating system on it (tested with RaspberryPi OS Buster)
- install **Docker** - we'll be running all the services in a docker container (e.g. https://phoenixnap.com/kb/docker-on-raspberry-pi)
- install **jq** (e.g. Linux Ubuntu/Debian: apt-get install jq) - for parsing the JSON responses from Spotify's Web API
- you need a **Premium Spotify** account which enables you to get an access and refresh token to controll their Web API - get it here, for more tips scroll to the end of this README: https://developer.spotify.com/documentation/general/guides/authorization-guide/

### IV. Preparation - setting it up
- clone the repository
- first build the docker image
- populate the .env.example file with the necessary values for host IP and spotify access as well as refresh token
- change permission to the controlspotify bash script
```
git clone https://github.com/FrancisHGR/forked-daapd-raspotify && cd forked-daapd-raspotify
docker build -t forked-daapd-raspotify .
cp .env.example .env
!!! enter .env file and put your spotify credentials and host IP in !!!
sudo chmod +x controlspotify
```

### V. Let's go
- run the docker container, giving it network mode host permission for all the alternating ports be reachable - IMPORTANT: Add your spotify username and password
- start spotify playback with all available airplay devices in your network from the attached bash script controlspotify
```
docker run -dit --rm --name forked-daapd-raspotify --net=host -e "username=INSERTNAME" -e "password=INSERTPASSWORD" forked-daapd-raspotify
./controlspotify continue
```
- ALTERNATIVE: For step 2, you can alternatively select desired speakers on webserver your-host-ip:3689 (select speakers in bottom right control panel) or run the script below and then select Spotify Connect device with name *Spotify-Smart-Home* in your spotify app and play song
```
./controlspotify connect_airplay
```

### DEEP DIVE
## Get a Spotify Web API token
- **! You absolutly need a Spotify Premium account !**
- General page: https://developer.spotify.com/documentation/general/guides/authorization-guide/
Steps
1. Register your app (=this program) here - click on *your Dashboard*: https://developer.spotify.com/documentation/general/guides/app-settings/#register-your-app
2. Follow any of those guides - https://github.com/lrholmes/spotify-auth-cli or https://www.youtube.com/watch?v=ZvGnvOShStI

 
 
 