---
layout: post
title: VictorOps Ruby Client Gem
description: "A Gem to provide a common interface and naming pattern for custom VictorOps integrations."
category: articles
tags: [ VictorOps, Ruby, Deployment, DevOps, Monitoring, gem, CI ]
image:
  feature: victorops-ruby-gem-info-rollup.png
---

[VictorOps](https://victorops.com/) is pretty awesome. Think an extensible, actionable Pagerduty. Somewhere where you can integrated DevOps tools to automate your escalation and response process all in one place. I have downed the Flavor Aid[^fn-jonestown] and bought in. They offer a plethora built in [integrations](http://victorops.force.com/knowledgebase/articles/Integration/Hubot-Integration) and a simple yet versatile [REST Alert API](http://victorops.force.com/knowledgebase/articles/Integration/Alert-Ingestion-API-Documentation/). They do not have an official ruby API client and I couldn't find one out there in the community, so I put one together this weekend.

Introducing the [`victor_ops-client` gem](https://rubygems.org/gems/victor_ops-client).[^fn-gem-naming] This came together based off of experience writing different bots for some of the clients I work for. It offers a common naming pattern for your `entity_display_name`s, `monitoring_tool` description and `routing_key` usage.[^fn-source-code]

Here is how to use it:

Install the gem

```
gem install victor_ops-client
```

Require it in your script

``` ruby
require 'victor_ops/client'
```

Initialize your client

``` ruby
# Required for Initializing Client
API_URL = 'INSERT_URL_HERE'
ROUTING_KEY = 'INSERT_ROUTING_KEY_HERE'

client = VictorOps::Client.new api_url: API_URL, routing_key: ROUTING_KEY
```

The `API_URL` is an `Incoming Webhook` URL provided by VictorOps. You can find it by looking at your `Settings -> Integrations -> REST Endpoint`. The `ROUTING_KEY` is URI compliant string that you would like to use to route messages within VitorOps and the [Transmogrifier](https://victorops.com/transmogrifier/).

On initialization you can pass in `host`, `name`, `entity_display_name` and `monitoring_tool` as extra values that will be used in the generation of alerts. If you don't, the tool will auto populate the values with defaults. I recommend that you pass in a `name` at the least. Any value that you pass in on initialization can be accessed directly through a `client.settings.#{value_name}` call.

Once you have established your client, you can send any of the supported alert messages to VictorOps with a simple interface and convenience methods.

``` ruby
# Send a CRITICAL alert
client.critical 'THE DISK IS FULL!!!'

# Send a WARNING alert
client.warn desc: 'Disk is nearing capacity', stats: `df -h`

# Send an INFO alert
client.info [ 'this', 'is', 'an', 'array' ]

# Send an ACKNOWLEDGMENT
client.ack 'bot ack'

# Send a RECOVERY
client.recovery desc: 'Disk has space', emoji: ':saiyan:'
```

Note that the payload you are sending can be either a `STRING`, `ARRAY` or `HASH`. The helper methods convert the input to the alert methods using [`awesome_print`](https://github.com/michaeldv/awesome_print). I do this so that you can pack important metadata into the `state_message` within VictorOps easily in the code.

<figure>
  <img src="/images/victorops-ruby-gem-info-rollup.png">
  <figcaption>Rollup info from Ruby Client</figcaption>
</figure>

<figure>
  <img src="/images/victorops-ruby-gem-info-details.png">
  <figcaption>Expanded details of the info from Ruby Client</figcaption>
</figure>

If you would like to take a look at the source code feel free to [take a look, fork, contribute.](https://github.com/clok/victor-ops-client)

I will be adding a persistence layer (most likely using [daybreak](http://propublica.github.io/daybreak/)) that will provide and interface to update previously posted incidents via the `entity_id`.

[^fn-jonestown]: Contrary to popular belief, it was Flavor Aid that was used at the [Jonestown Massacre](http://en.wikipedia.org/wiki/Jonestown) which is the morbid origin of the "Drink the Kool-Aid" saying.
[^fn-source-code]: Source code is on [Github, MIT Liscense](https://github.com/clok/victor-ops-client)
[^fn-gem-naming]: [RubyGems.org](http://guides.rubygems.org/name-your-gem/) has provided a very helpful explanation of gem [naming conventions](http://guides.rubygems.org/name-your-gem/) that I suggest looking at.