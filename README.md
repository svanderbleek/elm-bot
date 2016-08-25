# Elm-Bot

A lambdabot style bot for Elm-Lang with Slack integration.

## Build

`stack build`

## Run

To run on `localhost:port`:

`stack exec elm-bot -- port`

## API

The server responds to slash commands, see spec here:
https://api.slack.com/slash-commands

A form encoded request with at least a `text=..` will get
back a JSON response from evaluating the text with `elm-repl`.
The server responds with an empty `200` when `ssl_check=1` is passed.

## Deploy

AWS t2 micro Ubuntu 14.04 deploy:

```
ssh ubuntu@ip
sudo su root
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 575159689BEFB442
echo 'deb http://download.fpcomplete.com/ubuntu trusty main'|sudo tee /etc/apt/sources.list.d/fpco.list
apt-get update 
apt-get install stack -y
apt-get install libncurses5-dev -y
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs
npm install -g elm
git clone https://github.com/svanderbleek/elm-bot.git
cd elm-bot
stack setup
stack build
cp elm-bot.conf /etc/init/
service elm-bot start
```
make clode clmintae work or something
