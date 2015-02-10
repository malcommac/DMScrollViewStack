//
//  ExampleViewController.m
//  DMScrollViewStack
//
//  Created by daniele on 05/02/15.
//  Copyright (c) 2015 Daniele Margutti. All rights reserved.
//

#import "ExampleViewController.h"

@interface ExampleViewController () <UITableViewDataSource,UITableViewDelegate> {
	DMScrollViewStack		*stackScrollView;
	
	IBOutlet		UIView			*view1;
	IBOutlet		UIView			*view2;
	IBOutlet		UIView			*view3;
	IBOutlet		UIView			*view4;
	IBOutlet		UITableView		*tableView;
}

@property (nonatomic,retain)	NSArray		*viewsArray;

@end

@implementation ExampleViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	tableView.dataSource = self;
	self.viewsArray = @[view1,view2,view3,tableView,view4];
	

	
	stackScrollView = [[DMScrollViewStack alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(20, 10, 100, 10))];
	stackScrollView.backgroundColor = [UIColor lightGrayColor];
	stackScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:stackScrollView];

//	for (UIView *subview in self.viewsArray) {
//		[stackScrollView addSubview:subview animated:NO];
//	}
	[stackScrollView setViews:self.viewsArray];
}

- (UIColor *) randomColor {
	NSInteger aRedValue = arc4random()%255;
	NSInteger aGreenValue = arc4random()%255;
	NSInteger aBlueValue = arc4random()%255;
	
	UIColor *randColor = [UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];

	return randColor;
}

- (IBAction)add:(id)sender {
	UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(stackScrollView.frame), 100)];
	vi.backgroundColor = [self randomColor];
	[stackScrollView insertSubview:vi atIndex:0 animated:YES completion:NULL];
}

- (IBAction)addMiddle:(id)sender {
	UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(stackScrollView.frame), 100)];
	vi.backgroundColor = [self randomColor];
	[stackScrollView insertSubview:vi atIndex:1 animated:YES completion:NULL];
}

- (IBAction)addEnd:(id)sender {
	UIView *vi = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(stackScrollView.frame), 100)];
	vi.backgroundColor = [self randomColor];
	[stackScrollView addSubview:vi animated:YES completion:NULL];
}


- (IBAction)remove:(id)sender {
	[stackScrollView removeSubviewAtIndex:stackScrollView.contentViews.count-2 animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
	cell.textLabel.text = [NSString stringWithFormat:@"Row %ld",indexPath.row];
	return cell;
}

@end
