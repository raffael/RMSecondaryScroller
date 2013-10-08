# RMSecondaryScroller

This NSScroller sub-class can be used to get a second scroll bar for a NSScrollView instance. This can be useful if you want to have a scrollbar height which is different from the NSScrollView's height.

Instances of **RMSecondaryScroller** observe a NSScrollView and act as their NSScroller instance.

**NOTE:** Currently, only vertical NSScrollers are implemented.

## Usage

Drag a NSView instance in the Interface Builder to your window, e.g., next to the NSScrollView you want to be handled by the instance. Set its class to RMSecondaryScroller. The view will adjust its size automatically to the NSScroller's default knob width or height. Link the NSScrollView you want to observe using the **observedScrollView** outlet.

## Contact

* Raffael Hannemann
* [@raffael_me](http://www.twitter.com/raffael_me/)
* http://www.raffael.me/

## License

Copyright (c) 2013 Raffael Hannemann
Under BSD License.

## Want more?

Follow [@raffael_me](http://www.twitter.com/raffael_me/) for similar releases.