---
layout: post
title: Particle Generation in ImpactJS
description: ""
category: articles
tags: [ Box2d, Code, Experiment, Fun, Impact Engine, ImpactJS, JavaScript, Physics, PiSpace ]
image:
  feature: fireworks4.png
---

<figure>
  <img src="/images/fireworks4.png">
  <figcaption>Particle effects are made easy in ImpactJS</figcaption>
</figure>

I can’t say it enough just how empowering the ImpactJS Engine is as a developer. I thoroughly enjoy working with it everyday. Check out [PiSpace]({{ site.url }}/pispace) to see the code below in action.  Also, all my code for PiSpace is available on [github](https://github.com/clok/PiSpace) as an open repo.  The ImpactJS engine uses a modified version of John Resig’s [Simple Java Script Inheritance](http://ejohn.org/blog/simple-javascript-inheritance/) which makes extending and handling objects a breeze.  I enjoy working at a lower level than a GUI game editor, so this suits me well.  The process of creating a particle effect is as easy as spawning any other entity in the game world.  Start off by creating an *EntityParticle* by extending the ImpactJS *Entity*:

``` javascript
EntityParticle = ig.Entity.extend({
  // single pixel sprites
  size: { x:1, y:1 },
  offset: { x:0, y:0 },
 
  // particle will collide but not effect other entities
  type: ig.Entity.TYPE.NONE,
  checkAgainst: ig.Entity.TYPE.NONE,
  collides: ig.Entity.COLLIDES.LITE,
 
  // default particle lifetime & fadetime
  lifetime: 5,
  fadetime: 1,
 
  // particles will bounce off other entities when it collides
  minBounceVelocity: 0,
  bounciness: 1.0,
  friction: { x:0, y:0 },
```

Set some initial values to make the particle less interactive with other entities in the game world since we want the particle effects more for graphics and less for physics. In the *init* function we want to add some standard randomness to the velocities and tweak the animations to add a flickering effect by using the *currentAnim.gotoRandomFrame()* feature. This looks really good.

``` javascript
init: function( x, y, settings ){
    this.parent( x, y, settings );
 
    // take velocity and add randomness to vel
    var vx = this.vel.x; var vy = this.vel.y;
    this.vel.x = (Math.random()*2 - 1)*vx;
    this.vel.y = (Math.random()*2 - 1)*vy;
 
    // creates a flicker effect
    this.currentAnim.gotoRandomFrame();
 
    // init timer for fadetime
    this.idleTimer = new ig.Timer();
},
```

In the *update* function we will use the *lifetime* and *fadetime* instantiated in the object to fade it out over time and to determine when to remove the particle from the game world.

``` javascript
update: function(){
    // check if particle has existed past lifetime
    // if so, remove particle
    if(this.idleTimer.delta() > this.lifetime){
         this.kill();
         return;
    } 
 
    // fade the particle effect using the aplha blend
    this.currentAnim.alpha = this.idleTimer.delta().map( this.lifetime - this.fadetime, this.lifetime, 1, 0 );
    this.parent();
} 
 
});
```

Now, this isn’t a fully functioning entity but it will provide a good foundation as a parent class. Let’s make a *FireGib* that we can use as a particle for fireworks and collision effects by extending the parent class above, adding in the details we need to flesh out the object:

``` javascript
FireGib = EntityParticle.extend({
    // shorter lifetime
    lifetime: 1.0,
    fadetime: 0.5, 
 
    // velocity value to be set
    vel: null, 
 
    gravityFactor: 0, 
 
    // bounce a little less
    bounciness: 0.6, 
 
    // add animation sheet of sprites
    animSheet: new ig.AnimationSheet('media/sprites/burnpix.png',1,1), 
 
    init: function( x, y, settings ){
        // add ember animation
        this.addAnim( 'idle', 0.3, [0,1,2,3] ); 
 
        // update random velocity to create starburst effect
        this.vel = { x: (Math.random() < 0.5 ? -1 : 1)*Math.random()*100,
                     y: (Math.random() < 0.5 ? -1 : 1)*Math.random()*100 }; 
 
        // send to parent
        this.parent( x, y, settings );
    }
});
```

We shortened the *lifetime* and *fadetime* to have the particles behave like sparks, lowered the *bounciness* and loaded the *AnimationSheet*. In the *init* function we added the animation and established a more specific random velocity to create a star burst effect. And that’s it. This will generate a single pixel sprite that will flicker.

<figure>
  <img src="/images/fireworks.png">
  <figcaption>A single star burst effect on the title screen.</figcaption>
</figure>

To do to add a firework effect on a title screen is use some logic in the update function with a timer like so:

``` javascript
// Use timer to spawn fireworks every second
if ( this.fireTimer.delta() > 0 ){
    for (var i = 0; i <= 100; i++){
        ig.game.spawnEntity( FireGib, randPos.x, randPos.y );
    }
    this.fireTimer.reset();
}
```

<figure>
  <img src="/images/sparks.png">
  <figcaption>A single star burst effect on the title screen.</figcaption>
</figure>

On a collision with an entity we can generate a spark effect using similar logic:

``` javascript
// Take the vel.x values to consider relative "force of impact" and gen particles
// accordingly. Use 1/3 ratio for sanity.
var n = ((Math.abs(this.body.GetLinearVelocity().x) + Math.abs(edge.other.GetLinearVelocity().x))/3).round();
if (n > 30) {
    n = 30;
}
for ( var i = 0; i <= n; i++ ){
    ig.game.spawnEntity( FireGib, edge.other.entity.pos.x, edge.other.entity.pos.y );
}
```

The collision code above is using Box2DJS v2.1a, but the idea holds true with Impact collisions too.

I hope this little tutorial has proved helpful. I found [Jesse Freeman’s “Introducing HTML5 Game Development”](http://www.amazon.com/Introducing-HTML5-Development-Jesse-Freeman/dp/1449315178/ref=sr_1_1?ie=UTF8&qid=1331191652&sr=8-1) a helpful resource when starting out.  It’s a solid one stop shop for making a game with ImpactJS.  The [ImpactJS Forums](http://impactjs.com/forums/) are a fantastic resource for pointers and guidance too.  My next post will be on making particle effects using Box2DJS v2.1a.