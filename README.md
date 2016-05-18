# Elm-Bot

A lambdabot style bot for Elm-Lang with Slack integration.

## Build

`stack build`

## Run

To run on `localhost:3333`:

`stack exec elm-bot`

## API

The server responds to slash commands, see spec here:
https://api.slack.com/slash-commands

A form encoded request with at least a `text=..` will get
back a JSON response from evaluating the text with `elm-repl`.
The server responds with an empty `200` when `ssl_check=1` is passed.
