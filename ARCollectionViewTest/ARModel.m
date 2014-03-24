//
//  ARModel.m
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARModel.h"

@implementation ARModel

- (instancetype)initWithColour:(UIColor *)colour dimension:(CGFloat)dimension {
    self = [super init];
    
    if (self != nil) {
        _colour = colour;
        _dimension = dimension;
    }
    
    return self;
}

@end
