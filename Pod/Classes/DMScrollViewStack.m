//
//  DMScrollViewStack.m
//  Efficient vertical scroll view which can contains views/table/collection view and any subclass of scrollview
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 08/02/15.
//  Copyright (c) 2015 http://www.danielemargutti.com All rights reserved.
//	Distribuited under MIT License http://opensource.org/licenses/MIT
//

#import "DMScrollViewStack.h"

@interface DMScrollViewStack () {
	NSMutableOrderedSet		*viewsArray;
	NSMutableOrderedSet		*viewsArrayHeight; // expanded heights of the views
	// Dragging support
	UIView					*draggingView;
	CGPoint					 draggingLastPoint;
}

@end

@implementation DMScrollViewStack

#pragma mark - Initialization -

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// We want to mantain an internal array with the ordered list of the subviews and their best (expanded) height
		viewsArray = [[NSMutableOrderedSet alloc] init];
		viewsArrayHeight = [[NSMutableOrderedSet alloc] init];
	}
	return self;
}

- (void)dealloc {
	for (UIView *subview in viewsArray) {
		if ([subview isKindOfClass:[UIScrollView class]])
			[subview removeObserver:self forKeyPath:@"contentSize"];
	}
}

#pragma mark - Properties -

- (NSArray *)contentViews {
	return [viewsArray array];
}

#pragma mark - Manage Subviews -

- (void) setViews:(NSArray *) aSubviews {
	for (UIView *subview in aSubviews)
		[self insertSubview:subview atIndex:viewsArray.count animated:NO layout:NO scroll:NO];
	[self layoutSubviews];
}

- (void) addSubview:(UIView *)view animated:(BOOL) aAnimated {
	[self insertSubview:view atIndex:viewsArray.count animated:aAnimated];
}

- (void) insertSubview:(UIView *)aSubview atIndex:(NSInteger) aIdx animated:(BOOL) aAnimated  {
	[self insertSubview:aSubview atIndex:aIdx animated:aAnimated layout:YES scroll:YES];
}

- (void) insertSubview:(UIView *)aSubview atIndex:(NSInteger) aIdx animated:(BOOL) aAnimated
				layout:(BOOL) layoutImmediately scroll:(BOOL) scrollToMakeVisible {
	
	[self addSubview:aSubview];
	[viewsArray insertObject:aSubview atIndex:aIdx];
	BOOL isSubview = [aSubview isKindOfClass:[UIScrollView class]];
	[viewsArrayHeight addObject: @( (isSubview ? ((UIScrollView*)aSubview).contentSize.height : CGRectGetHeight(aSubview.frame) ) )];

	
	if ([aSubview isKindOfClass:[UIScrollView class]]) {
		((UIScrollView*)aSubview).scrollEnabled = NO;
		[aSubview addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
	}
	
	[self addLongTapGestureRecognizerTo:aSubview];
	
	// We will use it to perform a slide from bottom animation on add
	if (aIdx > 0 && aAnimated) {
		[self sendSubviewToBack:aSubview];
		aSubview.frame = CGRectMake(0,
									CGRectGetMaxY([self rectForSubviewAtIndex:aIdx-1])-CGRectGetHeight(aSubview.frame),
									CGRectGetWidth(self.frame),
									CGRectGetHeight(aSubview.frame));
	}
	
	if (layoutImmediately) // Perform a layout subviews immedately
		[self layoutSubviews:aAnimated completion:^{
			if (scrollToMakeVisible) // Scroll to make new item visible if required
				[self scrollRectToVisible:[self rectForSubviewAtIndex:aIdx] animated:aAnimated];
	}];
}

- (void) removeSubviewAtIndex:(NSInteger) aIdx animated:(BOOL) aAnimated {
	UIView *targetView = viewsArray[aIdx];
	if (aAnimated) {
		[viewsArray removeObjectAtIndex:aIdx];
		[self layoutSubviews:YES completion:^{
			targetView.alpha = 0.0f;
			if ([targetView isKindOfClass:[UIScrollView class]])
				[targetView removeObserver:self forKeyPath:@"contentSize"];
			[targetView removeFromSuperview];
		}];
	}
}

#pragma mark - Layout Methods -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"contentSize"]) {
		NSInteger idx = [viewsArray indexOfObject:object];
		if (idx != NSNotFound && [viewsArrayHeight[idx] floatValue] != ((UIScrollView*)object).contentSize.height) {
			viewsArrayHeight[idx] = [NSNumber numberWithFloat:((UIScrollView*)object).contentSize.height];
			[self layoutSubviews];
		}
	}
}

- (void) layoutSubviews {
	[self layoutSubviews:NO completion:NULL];
}

- (CGRect) rectForSubviewAtIndex:(NSInteger) aIdx {
	CGFloat offsetY = 0.0f;
	for (NSUInteger idx = 0; idx <= aIdx; ++idx) {
		if (idx == aIdx)
			return CGRectMake(0.0f,offsetY, self.frame.size.width,[viewsArrayHeight[idx] floatValue]);
		offsetY += [viewsArrayHeight[idx] floatValue];
	}
	return CGRectZero;
}

- (void) layoutSubviews:(BOOL) aAnimated completion:(void (^)(void)) aCompletion {
	// We put everything about the layout methods inside a block we can execute by animating frames or directly without animations
	void (^layoutBlock)(void) = ^void(void) {
		static BOOL isScrollView;
		static CGRect visibleRect;
		static CGFloat currentOffset;
		static CGRect idealFrame;
		static CGRect subviewFrame;
		
		// This is the visible portion of the enclosing scroll view
		// Any subview otherside this area will have a zero-frame (this is particularly useful for table/collections view where cells are allocated
		// and resued based upon the visible region of their container).
		visibleRect = CGRectMake(0.0f, self.contentOffset.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
		currentOffset = 0.0f;
		NSUInteger idx = 0;
		for (UIView *subview in viewsArray) {
			isScrollView = [subview isKindOfClass:[UIScrollView class]];
			// This is the ideal (expanded) frame of the subview
			idealFrame = [self rectForSubviewAtIndex:idx];
			// Real frame (subviewFrame) will be adjusted based upon the real visible area of the subview itself
			subviewFrame = idealFrame;
			if (CGRectIntersectsRect(visibleRect, idealFrame)) {
				// Subview is (at least partially) visible
				// With a simple view frame is the expanded frame (=idealFrame), so nothing to do in this case.
				// With a scroll view we set the size of the scroll big enough to fit only the visible dimension
				// The origin of the scrollview will be at max the top offset of the enclosing scrollview, height is adjusted based on the area
				// We should also adjust the scrollview's contentOffset in order to simulate a real scrolling of the enclosing scrollview
				if (isScrollView) {
					CGFloat endOfScrollReachedValue = 0;
					if (CGRectGetMinY(subviewFrame) < self.contentOffset.y) {
						// When the scrollview offset y is behind the current offset of the outer scroll view we
						// set the origin of the scrollview at y=0 and the height to the visible height of the scrollview itself from the outer view
						endOfScrollReachedValue = (self.contentOffset.y+self.frame.size.height - CGRectGetMaxY(idealFrame));
						subviewFrame.origin.y = self.contentOffset.y;
						((UIScrollView*)subview).contentOffset = CGPointMake(0,self.contentOffset.y-idealFrame.origin.y);
					} else {
						// We want to mantain the normal content offset until the table offset y > current visible offset
						((UIScrollView*)subview).contentOffset = CGPointZero;
					}
					CGFloat visibleHeight = MIN(self.contentSize.height,MAX(0,self.contentOffset.y+CGRectGetHeight(self.frame)-CGRectGetMinY(subviewFrame)));
					subviewFrame.size.height = visibleHeight-endOfScrollReachedValue;
				}
				
			} else {
				// If subview is invisible we can set it's frame to zero (with tables and collection view we can avoid loading hidden cells)
				subviewFrame = CGRectMake(0, subviewFrame.origin.y, CGRectGetWidth(self.frame), 0);
			}
			subview.frame = subviewFrame;
			currentOffset += CGRectGetHeight(idealFrame);
			++idx;
		}
		// Adjust the content size to reflect the total height of the subviews
		self.contentSize = CGSizeMake(CGRectGetWidth(visibleRect),currentOffset);
	};
	
	if (aAnimated) // we can execute it inside an animation
		[UIView animateWithDuration:0.25f animations:layoutBlock completion:^(BOOL finished) {
			if (aCompletion) aCompletion();
		}];
	else { // or directly without animation
		layoutBlock();
		if (aCompletion) aCompletion();
	}
}

#pragma mark - Reordering Support -

- (BOOL) addLongTapGestureRecognizerTo:(UIView *) aSubview {
	if (![viewsArray containsObject:aSubview])
		return NO;
	UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLong:)];
	[aSubview setUserInteractionEnabled:YES];
	[aSubview addGestureRecognizer:press];
	return YES;
}

- (void) handleLong:(UILongPressGestureRecognizer *) gesture {
	if (gesture.state == UIGestureRecognizerStateBegan) { // GESTURE BEGAN
		// Save the instance of dragging view so we don't touch it's frame during layoutSubviews while a dragging session is active
		draggingLastPoint = [gesture locationInView:self];
		draggingView = gesture.view;
		[self bringSubviewToFront:draggingView];
	} else if (gesture.state == UIGestureRecognizerStateChanged) { // GESTURE CHANGED
		// Evaluate the translation and move the draggingView's y coordinate according to it
		CGPoint location = [gesture locationInView:self];
		CGPoint translation = CGPointMake( (location.x - draggingLastPoint.x), (location.y - draggingLastPoint.y) );
		draggingView.center = CGPointMake(draggingView.center.x, draggingView.center.y+translation.y);
		
		// If we are at the top of another we want to shift it up to take space for our draggingView
		UIView *behindView = [self subviewBehindPoint:location];
		if (behindView) {
			if (CGRectGetMinY(draggingView.frame) <= CGRectGetMinY(behindView.frame)+MIN(CGRectGetHeight(behindView.frame),20)) {
				NSInteger exchangeBehindViewIdx = [viewsArray indexOfObject:behindView];
				NSInteger exchangeWithDraggingViewIdx = [viewsArray indexOfObject:draggingView];
				[viewsArray moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:exchangeWithDraggingViewIdx] toIndex:exchangeBehindViewIdx];
				[viewsArrayHeight moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:exchangeWithDraggingViewIdx] toIndex:exchangeBehindViewIdx];
				[self layoutSubviews:YES completion:NULL];
			}
		}
		
		draggingLastPoint = location;
		
		// Scroll contentoffset up/down during dragging to make draggingView always visible
		CGFloat visibleOffsetY;
		if (translation.y > 0) // scrolling down
			visibleOffsetY = CGRectGetMaxY(draggingView.frame)+(CGRectGetHeight(draggingView.frame)/3);
		else
			visibleOffsetY = CGRectGetMinY(draggingView.frame)-(CGRectGetHeight(draggingView.frame)/3);
		[self scrollRectToVisible:CGRectMake(0, visibleOffsetY, draggingView.frame.size.width, 1.0f) animated:NO];

	} else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) { // GESTURE ENDED
		// End gesture, place draggingView to it's new position
		draggingView = nil;
		[self layoutSubviews:YES completion:NULL];
	}
}

- (UIView *) subviewBehindPoint:(CGPoint) aPoint {
	for (UIView *subview in viewsArray)
		if (CGRectContainsPoint(subview.frame, aPoint) && subview != draggingView)
			return subview;
	return nil;
}

@end
