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
    return self;
}

- (NSRect) rectForPart:(NSScrollerPart)partCode {
	
	NSRect rect = [super rectForPart:partCode];
	if (partCode == NSScrollerKnobSlot) {

	} else if (partCode==NSScrollerKnob) {

	}

	return rect;
}

- (void) setHideObservedScrollViewScrollers:(BOOL)hideObservedScrollViewScrollers {
	_hideObservedScrollViewScrollers = hideObservedScrollViewScrollers;
	[_observedScrollView.verticalScroller setAlphaValue:(_hideObservedScrollViewScrollers)?0:1];
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
	[self setDoubleValue:0.5];
	[self setKnobStyle:NSScrollerKnobStyleDefault];
	//[_scroller setScrollerStyle:NSScrollerStyleOverlay];
	[self setEnabled:YES];
	[self setTarget:self];
	[self setAction:@selector(scrollValueChanged:)];
	
	// We need to track mouse-hover events
	[self updateTrackingAreas];
}

- (void) scrollValueChanged: (id) sender {
	float scrollValue = [self floatValue];
		
	NSPoint curOffset = [[_observedScrollView contentView] bounds].origin;
	NSPoint newOffset = curOffset;
	
	NSSize ownSize = [[_observedScrollView documentView] frame].size;
	newOffset.y = ceilf(ownSize.height - [_observedScrollView frame].size.height)* scrollValue;

	[[_observedScrollView contentView] scrollToPoint: newOffset];
	[_observedScrollView reflectScrolledClipView:[_observedScrollView contentView]];
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
	// If the instance is not layer-backed, make use of this to hide the black background:
    //NSDrawWindowBackground([self bounds]);
    //[self drawKnob];
}

- (void) setFloatValue:(float)aFloat {
	[super setFloatValue:aFloat];

	// If the float value changes, set up a timer to hide the knob after a period of time
	[self setAlphaValue:1.0];
	if (_fadeOutTimer) {
		[_fadeOutTimer invalidate];
	}
	_fadeOutTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
													 target:self
												   selector:@selector(fadeOut)
												   userInfo:nil
													repeats:NO];
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
