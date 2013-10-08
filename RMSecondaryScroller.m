//
//  RMSecondaryScroller.m
//
//  Created by Raffael Hannemann on 07.10.13.
//  Copyright (c) 2013 Raffael Hannemann. All rights reserved.
//

#import "RMSecondaryScroller.h"

@implementation RMSecondaryScroller

- (id)initWithFrame:(NSRect)frame
{
	// Correct the width of the scroller
	frame.origin.x += frame.size.width-[NSScroller scrollerWidth];
	frame.size.width = [NSScroller scrollerWidth];
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (NSRect) rectForPart:(NSScrollerPart)partCode {
	
	NSRect rect = [super rectForPart:partCode];
	if (partCode == NSScrollerKnobSlot) {

	} else if (partCode==NSScrollerKnob) {

	}

	return rect;
}

- (void) setObservedScrollView:(NSScrollView *)observedScrollView {
	_observedScrollView = observedScrollView;
	[_observedScrollView.verticalScroller setHidden:YES];
	[[NSNotificationCenter defaultCenter] addObserver: self
											 selector: @selector(observedScrollViewContentViewBoundsDidChangeNotification:)
												 name: NSViewBoundsDidChangeNotification
											   object: [_observedScrollView contentView]];
	

	[self setWantsLayer:YES];
	[self setKnobProportion:0.5];
	[self setKnobStyle:NSScrollerKnobStyleDefault];
	//[_scroller setScrollerStyle:NSScrollerStyleOverlay];
	[self setDoubleValue:0.3];
	[self setEnabled:YES];
	[self setTarget:self];
	[self setAction:@selector(scrollValueChanged:)];
	
	[self updateTrackingAreas];
}

- (void) scrollValueChanged: (id) sender {
	float scrollValue = [self floatValue];
		
	NSPoint curOffset = [[_observedScrollView contentView] bounds].origin;
	NSPoint newOffset = curOffset;
	
	NSSize ownSize = [[_observedScrollView documentView] frame].size;
	newOffset.y = ceilf(ownSize.height - [_observedScrollView frame].size.height)* scrollValue;
	// If our synced position is different from our current position, reposition our content view.
	
	//if (!NSEqualPoints(curOffset, changedBoundsOrigin)) {
	// Note that a scroll view watching this one will get notified here.
	[[_observedScrollView contentView] scrollToPoint: newOffset];
	// We have to tell the NSScrollView to update its scrollers.
	[_observedScrollView reflectScrolledClipView:[_observedScrollView contentView]];
	//}

}

- (void) observedScrollViewContentViewBoundsDidChangeNotification: (NSNotification *) notification {
	NSScroller *vert  = _observedScrollView.verticalScroller;
	[self setKnobProportion:vert.knobProportion];
	[self setDoubleValue:vert.doubleValue];
}


- (void) drawKnob {
	[super drawKnob];
	[super drawKnob];
	if (_hovered) {
		[super drawKnob];
		[super drawKnob];
	}
}
- (void) drawKnobSlotInRect:(NSRect)slotRect highlight:(BOOL)flag {
    //NSDrawWindowBackground([self bounds]);
    //[self drawKnob];
}

- (void)drawRect:(NSRect)dirtyRect
{
	
    /*[[NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:0.4] set];
	NSRectFill(self.bounds);
*/
	[super drawRect:dirtyRect];
}

- (void) setFloatValue:(float)aFloat {
	[self setAlphaValue:1.0];

	[super setFloatValue:aFloat];
	if (_fadeOutTimer) {
		[_fadeOutTimer invalidate];
	}
	_fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO];
}

- (void) mouseEntered:(NSEvent *)theEvent {
	if (_fadeOutTimer) {
		[_fadeOutTimer invalidate];
		_fadingOutDelayed = YES;
	}
	_hovered = YES;
}

- (void) mouseExited:(NSEvent *)theEvent {
	if (_fadingOutDelayed) {
		_fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(fadeOut) userInfo:nil repeats:NO];
		_fadingOutDelayed = NO;
	}
	_hovered = NO;
}

-(void)updateTrackingAreas
{
    if(_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
	
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void) fadeOut {
	if (_fadeOutTimer)
		[_fadeOutTimer invalidate];
	[self.animator setAlphaValue:0];
}
@end
