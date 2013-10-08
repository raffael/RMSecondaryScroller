//
//  RMSecondaryScroller.h
//  NSBlurViewTest
//
//  Created by Raffael Hannemann on 07.10.13.
//  Copyright (c) 2013 Raffael Hannemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** This NSScroller sub-class can be used to get a second scroll bar for a NSScrollView instance. This can be useful if you want to have a scrollbar height which is different from the NSScrollView's height. */
@interface RMSecondaryScroller : NSScroller {
	NSTimer *_fadeOutTimer;
	BOOL _fadingOutDelayed;
	BOOL _hovered;
	NSTrackingArea *_trackingArea;
}

@property (strong,nonatomic) IBOutlet NSScrollView *observedScrollView;
@property (assign,nonatomic) BOOL hideObservedScrollViewScrollers;

@end
