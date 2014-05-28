iBeacon-git
===========

When iBeacon was announced I was incredibly excited. As soon as I found bluetooth beacons online I ordered some and
began experimenting with them. My wife must have thought I was crazy putting these little beacons around our home.

My idea for an app with iBecaons was based on the fact that I am forgetful sometimes. I am supposed to take out the
trash and place it by the curb every Monday and Thursday morning for the valet trash service, but a lot of times I
forget. What I wanted was to have a way to say that "when I am near the kitchen on Monday or Thursday between 8am and 9am
show me the alert "Take out the trash!"". I began working on this premise and coding up a little app that I could use to
see how well this would work.

Unfortunately, my idea would not work out. In order for it to work seamlessly the iPhone would need to continue ranging
the beacons even when the app was in the background. Currently, ranging beacons only happens in the foreground or
when a background refresh is granted to the app.

While it is unfortunate the idea has not worked out yet I am still very excited about iBeacon and believe it will
be a part of how we interact with the world going forward.

I wonder if at some point Apple will add a way to be alerted on range to beacon changes. For example, right now
an app can get notified whenever the device enters a beacon region. This could be extended to allow an app to
subscribe to distance notifications to different beacons in that region. I could then say "subscribe to the event that the
beacon XXX is "near" the device".
