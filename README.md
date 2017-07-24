Goatr Incident Response Bot
=============


An incident response bot.  It automates things that need to happen before, during, and after an incident.  We all know that incidents can be like a goat rodeo, and this bot tries to make life as easy as possible during those hectic times.

### Commands

#### goatr incident start [name]

Creates a new slack channel with the name specified.
Invites all users within a certain usergroup to the channel.
Posts the escape protocol.

#### goatr set ic [name]

Sets the current channels topic to the incident commander's name.

#### Environment Variables

The bot loads some information from environment variables.  This might be more dynamic in the future.  

ENV['RESPONDERS_SLACK_USERGROUP_HANDLE']
ENV['RESPONDERS_SLACK_USERGROUP_ID']
ENV['BOT_SLACK_IDS']
ENV['SLACK_USER_TOKEN']
ENV['SLACK_API_TOKEN']

The bot will auto-invite people within a certain usergroup.  You should create a usergroup and then add all responders to this group.  If your usergroups is @incidentresponders, your ENV variable will look like.

RESPONDERS_SLACK_USERGROUP_HANDLE=incidentresponders
RESPONDERS_SLACK_USERGROUP_HANDLE=<slack_usergroup_id>

Certain actions like inviting to channels can only be performed by users and not bots, so it is the user that is performing certain actions.  If you are one of the responders, you should create a separate slack user for use with this automation. 

SLACK_USER_TOKEN=<a slack user token>
SLACK_API_TOKEN=<the bot's slack api token>
  
It will also autoinvite any other bots into the channel (they cannot belong to usegroups so they are listed separately). Make sure you add the ids of any slack bots you want invited, as well as the id of the bot itself, so that the user invites the bot into the new incident channel.  It is a comma separated list

BOT_SLACK_IDS=<slack_bot_id_1>,<slack_bot_id2>,<slack_bot_id_3>

#### Coming Soon

Next step will be to add a redis connection to persist incident information regarding start time, end time, incident commander name, and other stuff. 

A means of exporting the incident channel history into a format useful for a post-mortem timeline.

## Copyright and License

Copyright (c) 2015, Bobby Martinez

This project is licensed under the [MIT License](LICENSE.md).
