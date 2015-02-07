---
layout: post-no-feature
title: emacs find ; and replace with blank line
description: "... or you could use jsbeautifier.org"
category: articles
tags: [ Code, emacs, JavaScript ]
---

<figure>
  <img src="/images/emacs_split.png">
  <figcaption>GNU Emacs 23.1</figcaption>
</figure>

The power of a capable editor can’t be overvalued as a developer.  From the “simplicity” of VI at the surface to the feature-full display of an IDE like Eclipse, each editor has it’s group of fans and haters.  I am, personally, a GNU Emacs user and proud of it.  There is nothing that Emacs can’t do and if somehow you can’t figure out how to do it in Emacs you can always just write an EmacsLisp extension to do it.  I could go on and on about the joys of getting to know Emacs, but I will just keep this short.

This weekend I ran into some ported C++ to ActionScript, then ported from ActionScript to JavaScript code that was then baked.  I was finding it hard to debug some run-time errors that I had, so I wanted to take the baked code and make it more useful for debugging.  The library was roughly 500 “lines” in the form I was working with. It all looked much like this:

``` javascript
a=b2.Vec2.prototype;a.x=0;a.y=0;a.SetZero=function(){this.y=this.x=0};a.Set=function(b,c){this.x=b;this.y=c};a.SetV=function(b){this.x=b.x;this.y=b.y};a.Negative=function(){return new b2.Vec2(-this.x,-this.y)};a.Copy=function(){return new b2.Vec2(this.x,this.y)};a.Add=function(b){this.x+=b.x;this.y+=b.y};a.Subtract=function(b){this.x-=b.x;this.y-=b.y};
a.Multiply=function(b){this.x*=b;this.y*=b};a.MulM=function(b){var c=this.x;this.x=b.col1.x*c+b.col2.x*this.y;this.y=b.col1.y*c+b.col2.y*this.y};a.MulTM=function(b){var c=b2.Math.Dot(this,b.col1);this.y=b2.Math.Dot(this,b.col2);this.x=c};a.CrossVF=function(b){var c=this.x;this.x=b*this.y;this.y=-b*c};a.CrossFV=function(b){var c=this.x;this.x=-b*this.y;this.y=b*c};
```
<br>
This made it VERY difficult to understand why my objects weren’t behaving properly.  Using the following commands I (1) found all *;* and added a blank line after it, (2) found all *{* added a blank line after it, (3) found all *};* added a blank line after it, and (4) auto formatted it to 4 space tabs.

<figure>
  <img src="/images/emacs_jumbled_mess.png">
  <figcaption>Before</figcaption>
</figure>

``` plaintext
<C-x h> <M-%> then `;` <enter>  `;`  <C-q C-j>  <enter> <!>
<C-x h> <M-%> then `{` <enter> `{` <C-q C-j> <enter> <!>
<C-x h> <M-%> then `};` <enter> <C-q C-j> `};` <enter> <!>
<C-x h> <C-M-\>
Note: Do not tpye back-ticks. <action> means to perform that user input.
```
<br>
<figure>
  <img src="/images/emacs_cleaned_up.png">
  <figcaption>After</figcaption>
</figure>

The above code went from that jumbled mess to what you see below:

``` javascript
a=b2.Vec2.prototype;
a.x=0;
a.y=0;
a.SetZero=function(){
    this.y=this.x=0
};
a.Set=function(b,c){
    this.x=b;
    this.y=c
};
a.SetV=function(b){
    this.x=b.x;
    this.y=b.y
};
a.Negative=function(){
    return new b2.Vec2(-this.x,-this.y)
};
a.Copy=function(){
    return new b2.Vec2(this.x,this.y)
};
a.Add=function(b){
    this.x+=b.x;
    this.y+=b.y
};
a.Subtract=function(b){
    this.x-=b.x;
    this.y-=b.y
};
a.Multiply=function(b){
    this.x*=b;
    this.y*=b
};
a.MulM=function(b){
    var c=this.x;
    this.x=b.col1.x*c+b.col2.x*this.y;
    this.y=b.col1.y*c+b.col2.y*this.y
};
a.MulTM=function(b){
    var c=b2.Math.Dot(this,b.col1);
    this.y=b2.Math.Dot(this,b.col2);
    this.x=c
};
a.CrossVF=function(b){
    var c=this.x;
    this.x=b*this.y;
    this.y=-b*c
};
a.CrossFV=function(b){
    var c=this.x;
    this.x=-b*this.y;
    this.y=b*c
};
```

What’s happening here?

*\<C-x h\>* is a command to select the entire document, read C as Control. *\<M-%\>*, read as Macro (alt), is the command for Query and Replace.  This will bring up a `shell` at the bottom of the screen for user input. First type in the string you want to search for, then type the string you want to replace it with.  Once you hit enter to finish the search, Emacs will highlight all the completions of the search in the document or within the selection.  You can use *\<space\>* to select each query individually, or you can use *\<!\>* to force a replace across all findings.  This is a VERY powerful tool in Emacs.  The interesting stuff is happening with the *\<C-q C-j\>* command.  Pressing this key sequence while in the Query and Replace will add a newline to the shell search. In effect, this will add the blank line at the end of the replace.  Not sure how to do this in other editors. The final command is the *\<C-M-\\>* command.  This will take all selected code and attempt to auto indent/format it.  I use this a lot at work and in my hobby coding.

All these commands took about 30 seconds to enter and execute, taking that ~500 line library and formatting it into a much more useful debugging tool at ~7000 lines of SLOC. It took me some time to learn Emacs key commands, but they are empowering as a developer.  Best part is, I know I will continue to learn more and more commands each day.