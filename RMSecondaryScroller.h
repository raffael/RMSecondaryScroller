//
//  RMSecondaryScroller.h
//  NSBlurViewTest
//
//  Created by Raffael Hannemann on 07.10.13.
//  Copyright (c) 2013 Raffael Hannemann. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/** */
@interface RMSecondaryScroller : NSScroller {
	NSTimer *_fadeOutTimer;
	BOOL _fadingOutDelayed;
	BOOL _hovered;
	NSTrackingArea *_trackingArea;
}

@property (strong,nonatomic) IBOutlet NSScrollView *observedScrollView;

@end
