---
layout: post
title: emacs-ify your Sublime Text
description: "Why? Because I have 10 fingers."
category: articles
tags: [ Sublime Text, emacs, JavaScript ]
image:
  feature: http://en.tiraecol.net/modules/comic/cache/images/tiraecol_en-2.png
---

<figure>
  <img src="http://en.tiraecol.net/modules/comic/cache/images/tiraecol_en-2.png">
  <figcaption>emacs? Really?!?</figcaption>
</figure>

In the early days, I had to make a choice between [VIM or emacs](http://i2.wp.com/imgs.xkcd.com/comics/real_programmers.png?resize=740%2C406). I chose [emacs](http://www.gnu.org/software/emacs/). Most would say I chose wrong. [Maybe I did...](http://vimcasts.org/images/blog/mate-vim-emacs.png) what I do know now is that I am comfortable with both, but I really enjoyed messing around with emacs lisp macros. Then came along Sublime text. When I converted from a purely *NIX development environment to a Mac dominated shop, I found myself wanting a different editor. I like the customization and integrations that Sublime text offers, but was not happy about some of the key mappings. I got used to using my elbows and fingers to execute macros.

Luckily, there are a lot of us emacs users converting to ST. There is a great package called [sublemacspro](https://github.com/grundprinzip/sublemacspro) that ports the majority of base emacs macros. Below are a few key mappings I have added to Sublime text that has allowed me to completely drop emacs. The `swap_line` commands are incredibly useful.

Just go to: `Sublime Text` -> `Preferences` -> `Key Bindings - User` and paste the following macros.

``` javascript
[{
  "keys": ["alt+up"],
  "command": "swap_line_up"
}, {
  "keys": ["alt+down"],
  "command": "swap_line_down"
}, {
  "keys": ["ctrl+shift+5"],
  "command": "show_panel",
  "args": {
    "panel": "replace",
    "reverse": false
  }
}, {
  "keys": ["home"],
  "command": "move_to",
  "args": {
    "to": "bol",
    "extend": false
  }
}, {
  "keys": ["end"],
  "command": "move_to",
  "args": {
    "to": "eol",
    "extend": false
  }
}]
```
<figure>
  <img src="http://i2.wp.com/imgs.xkcd.com/comics/real_programmers.png?resize=740%2C406">
  <figcaption>emacs FTW</figcaption>
</figure>

If you are at all curious, here are my module specific settings:

```
{
  "color_scheme": "Packages/Color Scheme - Default/Twilight.tmTheme",
  "font_size": 14,
  "highlight_line": true,
  "ignored_packages": [
    "Theme - Farzher",
    "Vintage"
  ],
  "perltidy_cmd": "/usr/local/bin/perltidy",
  "perltidy_options": [
    "-l=78",
    "-i=3",
    "-ci=3",
    "-st",
    "-se",
    "-vt=2",
    "-cti=0",
    "-pt=1",
    "-bt=1",
    "-sbt=1",
    "-bbt=1",
    "-nsfs",
    "-nolq",
    "-wbb=\"% + - * / x != == >= <= =~ !~ < > | & >= < = **= += *= &= <<= &&= -= /= |= >>= ||= .= %= ^= x=\""
  ],
  "soda_folder_icons": true,
  "theme": "Soda Dark 3.sublime-theme",
}
```