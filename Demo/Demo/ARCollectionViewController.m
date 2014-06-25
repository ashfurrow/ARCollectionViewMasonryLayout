//
//  ARCollectionViewController.m
//  ARCollectionViewTest
//
//  Created by Ash Furrow on 2014-03-22.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARCollectionViewController.h"
#import "ARCollectionViewMasonryLayout.h"
#import "ARCollectionViewCell.h"
#import <EDColor/UIColor+iOS7.h>
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

    // Configure our collection view;
    [self.collectionView registerClass:[ARCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];

    // Set up our model backing the collection view
    [self generateModelArray];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Private Methods

// Model array needs to be reproducible on each launch instead of random, for the integration tests.
- (void)generateModelArray
{
    NSMutableArray *mutableArray = [NSMutableArray array];
    for(NSInteger i = 0; i < self.colorCount; i++) {
        CGFloat dimension = (CGFloat)(i*10 % 30) + 40;
        UIColor *color = [UIColor iOS7Colors][i % [UIColor iOS7Colors].count];
        ARModel *model = [[ARModel alloc] initWithColor:color dimension:dimension];
        [mutableArray addObject:model];
    }
 
    self.modelArray = [NSArray arrayWithArray:mutableArray];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ARCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.item];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] || [kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kind forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    } else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(ARCollectionViewMasonryLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return self.headerSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(ARCollectionViewMasonryLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return self.footerSize;
}

#pragma mark - ARCollectionViewMasonryLayoutDelegate Methods

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(ARCollectionViewMasonryLayout *)collectionViewLayout variableDimensionForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.modelArray[indexPath.row] dimension];
}

@end
