//
//  ARModel.m
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARModel.h"

@implementation ARModel

- (instancetype)initWithColor:(UIColor *)color dimension:(CGFloat)dimension {
    self = [super init];
    
    if (self != nil) {
        _color = color;
        _dimension = dimension;
    }
    
    return self;
}

@end
