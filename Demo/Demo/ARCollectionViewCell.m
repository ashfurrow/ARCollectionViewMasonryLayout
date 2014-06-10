//
//  ARCollectionViewCell.m
//  Demo
//
//  Created by Daniel Doubrovkine on 6/10/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARCollectionViewCell.h"

@implementation ARCollectionViewCell

- (void)setModel:(ARModel *)model
{
    self.backgroundColor = model.color;
}

@end
