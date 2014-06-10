//
//  ARCollectionViewCell.h
//  Demo
//
//  Created by Daniel Doubrovkine on 6/10/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARModel.h"

@interface ARCollectionViewCell : UICollectionViewCell
@property(weak, nonatomic) ARModel *model;
@end
