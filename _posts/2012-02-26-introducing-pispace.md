---
layout: post-no-feature
title: Introducing PiSpace
description: ""
category: articles
tags: [ Box2d, CDFrost, Code, Impact Engine, ImpactJS, JavaScript, Physics ]
---

<figure>
  <img src="/images/pispace.png">
  <figcaption>So much fun to make.</figcaption>
</figure>

A week later and another fun Sunday afternoon with Impact and Box2D has amounted to the [PiSpace]({{ site.url }}/pispace) Alpha. ‘Pong in Space’ was a simple idea that came about during a talk I attended at last year’s GDC.  The lead physics programmer at Volition commented that, “Pong with physics is a horrible game, that’s why it’s best to fake some results to make things fun.”  After working on this game I have to disagree with him.  This is very much an alpha and a work in progress, but I am very happy with it’s current state. New features below!

New features since the initial post last week:

* Random start velocity vector for Puck
* “Better” CPU AI
* Tunneling protection for Paddles and Puck
* Puck Tunneling results in random location and velocity for Puck
* Added OST loops provided by [CDFrost](http://soundcloud.com/twilightcalzone)
* Added soundFX generated using [Bfxr](http://www.bfxr.net/)
* New Splash page to represent the Impact Engine
* New score system (There’s actually a point now!)
* Tuned player controls

Near-term features to be added:

* 2 Player mode
* Particle effects for vector thrusting
* Particle effects on puck contact
* Title Screen
* Better page integration
* Add paddle animations
* Power-ups (ex: opponent paddle becomes susceptible to rotation for a short period)
* “Tunneling” graphical effects
* Mobile controls (touch and accel)

Known Bugs:

* Box2D v2.0.2 destroyProxy handling
* Paddle/Wall penetration

Enjoy!