//
//  DMScrollViewStack.h
//  Efficient vertical scroll view which can contains views/table/collection view and any subclass of scrollview
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 08/02/15.
//  Copyright (c) 2015 http://www.danielemargutti.com All rights reserved.
//	Distribuited under MIT License http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

@interface DMScrollViewStack : UIScrollView { }

@property (nonatomic,readonly)	NSArray		*contentViews;

- (void) setViews:(NSArray *) aSubviews;
- (void) addSubview:(UIView *)view animated:(BOOL) aAnimated;
- (void) insertSubview:(UIView *)view atIndex:(NSInteger) aIdx animated:(BOOL) aAnimated;
- (void) removeSubviewAtIndex:(NSInteger) aIdx animated:(BOOL) aAnimated;

- (BOOL) addLongTapGestureRecognizerTo:(UIView *) aSubview;

@end
