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

static inline CGFloat randomColourComponent() {
    u_int32_t randomNumber = arc4random() % 256;
    
    return (CGFloat)randomNumber / 256.0f;
}

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
    const NSInteger capacity = 1000;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:capacity];
    
    for (NSInteger i = 0; i < capacity; i++) {
        UIColor *randomColour = [UIColor colorWithRed:randomColourComponent() green:randomColourComponent() blue:randomColourComponent() alpha:1.0f];
        CGFloat randomDimension = (CGFloat)(arc4random() % 80) + 40; // Generates a random dimension between [40...120].
        
        ARModel *model = [[ARModel alloc] initWithColour:randomColour dimension:randomDimension];
        [mutableArray addObject:model];
    }
    
    self.modelArray = [NSArray arrayWithArray:mutableArray];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
