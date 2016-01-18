//
//  ARCollectionViewController.h
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ARCollectionViewController : UICollectionViewController
@property(assign) NSInteger colorCount;
@property(assign) CGSize headerSize;
@property(assign) CGSize stickyHeaderSize;
@property(assign) CGSize footerSize;
@property(strong) NSArray *heightPerEntry;
@end
