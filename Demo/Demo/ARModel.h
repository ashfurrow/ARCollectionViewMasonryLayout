//
//  ARModel.h
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARModel : NSObject

- (instancetype)initWithColor:(UIColor *)color dimension:(CGFloat)dimension;

@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, assign, readonly) CGFloat dimension;

@end
