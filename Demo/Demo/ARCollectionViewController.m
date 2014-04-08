//
//  ARCollectionViewController.m
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARCollectionViewController.h"
#import "ARCollectionViewMasonryLayout.h"
#import "ARModel.h"

@interface ARCollectionViewController () <ARCollectionViewMasonryLayoutDelegate>

@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation ARCollectionViewController

static NSString *CellIdentifier = @"Cell";

#pragma mark - UIViewController Lifecycle and Callbacks

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure our collection view;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    // Set up our model backing the collection view
    [self generateModelArray];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Methods

// Model array needs to be reproducible on each launch instead of random, for the integration tests.
- (void)generateModelArray {
    const NSInteger capacity = 100;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:capacity];
    
    for (NSInteger i = 0; i < capacity; i++) {
        CGFloat red = (i*30 % 100) / 255.0f;
        CGFloat green = (i*30 % 100 + 100) / 255.0f;
        CGFloat blue = (i*30 % 100 + 155) / 255.0f;
        
        UIColor *randomColour = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        CGFloat randomDimension = (CGFloat)(i*10 % 30) + 40; // Generates a dimension between [40...70).
        
        ARModel *model = [[ARModel alloc] initWithColour:randomColour dimension:randomDimension];
        [mutableArray addObject:model];
    }
    
    self.modelArray = [NSArray arrayWithArray:mutableArray];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [self.modelArray[indexPath.item] colour];
    
    return cell;
}

#pragma mark - ARCollectionViewMasonryLayoutDelegate Methods

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ARCollectionViewMasonryLayout *)collectionViewLayout variableDimensionForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.modelArray[indexPath.row] dimension];
}

@end
