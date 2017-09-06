Goatr Incident Response Bot
=============


An incident response bot.  It automates things that need to happen before, during, and after an incident.  We all know that incidents can be like a goat rodeo, and this bot tries to make life as easy as possible during those hectic times.

### Commands

#### goatr start incident [name]

Creates a new Slack channel with the name specified.
Invites all users within a certain usergroup to the channel.
Posts the escape protocol.

#### goatr I am IC

Sets the current channels topic to the incident commander's name, which is the Slack user that issues this command.

#### Environment Variables

The bot loads some information from environment variables.  This might be more dynamic in the future.  

ENV['RESPONDERS_SLACK_USERGROUP_HANDLE']

ENV['RESPONDERS_SLACK_USERGROUP_ID']

ENV['BOT_SLACK_IDS']

ENV['SLACK_USER_TOKEN']

ENV['SLACK_API_TOKEN']

ENV['REDIS_URL']

The bot will auto-invite people within a certain usergroup.  You should create a usergroup and then add all responders to this group.  If your usergroup is @incidentresponders, your ENV variable will look like.

RESPONDERS_SLACK_USERGROUP_HANDLE=incidentresponders

RESPONDERS_SLACK_USERGROUP_HANDLE=<Slack usergroup id>

Certain actions like inviting to channels can only be performed by users and not bots, so it is the user that is performing certain actions.  If you are one of the responders, you should create a separate slack user for use with this automation.

SLACK_USER_TOKEN=<a slack user token>

SLACK_API_TOKEN=<the bot's slack api token>

It will also autoinvite any other bots into the channel (they cannot belong to usegroups so they are listed separately). Make sure you add the ids of any slack bots you want invited, as well as the id of the bot itself, so that the user invites the bot into the new incident channel.  It is a comma separated list

BOT_SLACK_IDS=<slackbot id 1>,<slackbot id 2>,<slackbot id 3>

You will need a Redis server so that this information can be persisted. You should specify the connection URL in the REDIS_URL variable.

REDIS_URL=redis://<user>:<password>@<redis server>:<port number>

This bot uses the redis client gem, and the client object is instantiated as such.

Redis.new(url:ENV['REDIS_URL'])

#### Coming Soon

A means of exporting the incident channel history into a format useful for a post-mortem timeline.

## Copyright and License

Copyright (c) 2017, Bobby Martinez

This project is licensed under the [MIT License](LICENSE.md).
