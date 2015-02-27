//
//  DMScrollViewStack.h
//  Efficient vertical scroll view which can contains views/table/collection view and any subclass of scrollview
//
//  Created by Daniele Margutti (me@danielemargutti.com) on 08/02/15.
//  Copyright (c) 2015 http://www.danielemargutti.com All rights reserved.
//	Distribuited under MIT License http://opensource.org/licenses/MIT
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMScrollViewStackLayoutMode) {
	DMScrollViewStackLayoutModeZeroAll,					// set to CGRectZero all subviews (classic uiviews and scroll view subclasses)
	DMScrollViewStackLayoutModeZeroOnlyScrollView		// set to CGRectZero only scroll view subclasses (this is the default behaviour)
};

@class DMScrollViewStack;

@protocol DMScrollViewStackReorderDelegate <NSObject>

@optional
- (void) stack:(DMScrollViewStack *) stack willMoveSubview:(UIView *) aSubview atIndex:(NSInteger) aIdx;
- (void) stack:(DMScrollViewStack *) stack didMoveSubview:(UIView *) aSubview;
- (BOOL) stack:(DMScrollViewStack *)stack shouldMoveSubview:(UIView *) aSubview atIndex:(NSInteger) aIdx;

@end


@interface DMScrollViewStack : UIScrollView { }

/**
 *  Read only copy of the subviews inside the stack
 */
@property (nonatomic,readonly)	NSArray		*contentViews;

/**
 *  YES to allows reordering with long-tap on subview and drag
 */
@property (nonatomic,assign)	BOOL		 allowsReordering;

/**
 *  Setup layout mode in -layoutSubviews
*/
@property (nonatomic,assign)	DMScrollViewStackLayoutMode	layoutMode;

/**
 *  Reorder actions delegate
 */
@property (nonatomic,weak)		id <DMScrollViewStackReorderDelegate>	reorderDelegate;

/**
 *  Set order subviews of the stack (from the top)
 *
 *  @param aSubviews list of ordered subviews to set (any other existing subview will be removed)
 */
- (void) setViews:(NSArray *) aSubviews;

/**
 *  Append a new subview at the bottom of the stack
 *
 *  @param aSubview  subview to place at the bottom of the stack
 *  @param aAnimated YES to animate the operation
 *  @param aCompletion define a completion block to execute at the end of the operation
 */
- (void) addSubview:(UIView *) aSubview animated:(BOOL) aAnimated completion:(void(^)(void)) aCompletion;

/**
 *  Inset a new subview at specified index of the stack
 *
 *  @param aSubview    subview to place
 *  @param aIdx        destination index
 *  @param aAnimated YES to animate the operation
 *  @param aCompletion define a completion block to execute at the end of the operation
 */
- (void) insertSubview:(UIView *)aSubview atIndex:(NSInteger) aIdx animated:(BOOL) aAnimated completion:(void (^)(void)) aCompletion;

/**
 *  Remove subview at index
 *
 *  @param aIdx      index of the subview to remove from the stack
 *  @param aAnimated YES to animate the operation
 *  @param aCompletion define a completion block to execute at the end of the operation
 */
- (void) removeSubviewAtIndex:(NSInteger) aIdx animated:(BOOL) aAnimated completion:(void (^)(void)) aCompletion;

/**
 *  Scroll to specified subview
 *
 *  @param aSubview	target subview
 *	@param aAnimated YES to animate scroll
**/
- (void) scrollToSubview:(UIView *) aSubview animated:(BOOL)animated;

@end
