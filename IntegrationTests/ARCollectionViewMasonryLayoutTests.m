//
//  ARCollectionViewMasonryLayoutTests.m
//  Demo
//
//  Created by Ash Furrow on 2014-04-07.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARCollectionViewMasonryLayout.h"
#import "_ARCollectionViewMasonryAttributesGrid.h"

#import "ARCollectionViewController.h"

static UICollectionViewLayoutAttributes *
LayoutAttributes(CGRect frame) {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes new];
    attributes.frame = frame;
    return attributes;
}

SpecBegin(ARCollectionViewMasonryLayoutTests)

describe(@"_ARCollectionViewMasonryAttributesGrid", ^{
    __block _ARCollectionViewMasonryAttributesGrid *grid = nil;

    beforeEach(^{
        grid = [[_ARCollectionViewMasonryAttributesGrid alloc] initWithSectionCount:3
                                                                          direction:ARCollectionViewMasonryLayoutDirectionVertical];
    });

    it(@"creates a list of empty sections", ^{
        expect([grid isSectionEmpty:0]).to.equal(YES);
        expect([grid isSectionEmpty:1]).to.equal(YES);
        expect([grid isSectionEmpty:2]).to.equal(YES);
    });

    it(@"adds item attributes to the grid", ^{
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes new];
        [grid addAttributes:attributes toSection:0];
        expect([grid attributesAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]).to.equal(attributes);

        expect([grid isSectionEmpty:0]).to.equal(NO);
        expect([grid isSectionEmpty:1]).to.equal(YES);
        expect([grid isSectionEmpty:2]).to.equal(YES);
    });

    describe(@"with items in each section", ^{
        beforeEach(^{
            [grid addAttributes:LayoutAttributes(CGRectMake(  0,  0, 100, 10)) toSection:0];
            [grid addAttributes:LayoutAttributes(CGRectMake(  0, 10, 100, 10)) toSection:0];
            [grid addAttributes:LayoutAttributes(CGRectMake(100,  0, 100, 20)) toSection:1];
            [grid addAttributes:LayoutAttributes(CGRectMake(100, 20, 100, 20)) toSection:1];
            [grid addAttributes:LayoutAttributes(CGRectMake(200,  0, 100, 30)) toSection:2];
            [grid addAttributes:LayoutAttributes(CGRectMake(200, 30, 100, 30)) toSection:2];
        });

        it(@"returns the total dimension for a section (in the configured direction)", ^{
            expect([grid dimensionForSection:0]).to.equal(20);
            expect([grid dimensionForSection:1]).to.equal(40);
            expect([grid dimensionForSection:2]).to.equal(60);
        });

        it(@"returns what the shortest section is", ^{
            expect(grid.shortestSection).to.equal(0);
            [grid addAttributes:LayoutAttributes(CGRectMake(0, 20, 100, 100)) toSection:0];
            expect(grid.shortestSection).to.equal(1);
            [grid addAttributes:LayoutAttributes(CGRectMake(0, 40, 100, 100)) toSection:1];
            expect(grid.shortestSection).to.equal(2);
        });

        it(@"returns the longest section's dimension", ^{
            expect(grid.longestSectionDimension).to.equal(60);
            [grid addAttributes:LayoutAttributes(CGRectMake(0, 20, 100, 100)) toSection:0];
            expect(grid.longestSectionDimension).to.equal(120);
            [grid addAttributes:LayoutAttributes(CGRectMake(0, 40, 100, 100)) toSection:1];
            expect(grid.longestSectionDimension).to.equal(140);
        });
    });
});

__block ARCollectionViewMasonryLayout *layout = nil;

describe(@"horizontal layout", ^{
    beforeEach(^{
        layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionHorizontal];
    });
    
    it(@"has default values when initialized", ^{
        expect(layout.rank).to.equal(2);
        expect(layout.dimensionLength).to.equal(120);
        expect(layout.contentInset).to.equal(UIEdgeInsetsZero);
        expect(layout.itemMargins).to.equal(CGSizeZero);
        expect(layout.collectionViewContentSize.width).to.equal(0);
    });
    
    it(@"has the correct horizontal direction", ^{
        expect(layout.direction).to.equal(ARCollectionViewMasonryLayoutDirectionHorizontal);
    });
    
    it(@"displays cells", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 5;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontal");
        expect(layout.collectionViewContentSize.width).to.equal(140);
    });
    
    it(@"displays footer", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.footerSize = CGSizeMake(20, 0);
        viewController.colorCount = 7;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalWithFooter");
        expect(layout.collectionViewContentSize.width).to.equal(200);
    });

    it(@"displays footer only", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.footerSize = CGSizeMake(20, 0);
        viewController.colorCount = 0;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalFooterOnly");
        expect(layout.collectionViewContentSize.width).to.equal(20);
    });

    it(@"displays header", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.headerSize = CGSizeMake(10, 0);
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalWithHeader");
        expect(layout.collectionViewContentSize.width).to.equal(110);
    });

    it(@"displays header only", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.headerSize = CGSizeMake(10, 0);
        viewController.colorCount = 0;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalHeaderOnly");
        expect(layout.collectionViewContentSize.width).to.equal(10);
    });

    it(@"displays header and footer", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.headerSize = CGSizeMake(3, 0);
        viewController.footerSize = CGSizeMake(5, 0);
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalWithHeaderAndFooter");
        expect(layout.collectionViewContentSize.width).to.equal(108);
    });
});

describe(@"vertical layout", ^{
    beforeEach(^{
        layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
    });
    
    it(@"has the correct vertical direction", ^{
        expect(layout.direction).to.equal(ARCollectionViewMasonryLayoutDirectionVertical);
    });
    
    it(@"displays cells", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 7;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"vertical");
        expect(layout.collectionViewContentSize.height).to.equal(180);
    });

    it(@"displays footer", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.footerSize = CGSizeMake(0, 20);
        viewController.colorCount = 7;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalWithFooter");
        expect(layout.collectionViewContentSize.height).to.equal(200);
    });

    it(@"displays footer only", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.footerSize = CGSizeMake(0, 20);
        viewController.colorCount = 0;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalFooterOnly");
        expect(layout.collectionViewContentSize.height).to.equal(20);
    });

    it(@"displays header", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.headerSize = CGSizeMake(0, 10);
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalWithHeader");
        expect(layout.collectionViewContentSize.height).to.equal(110);
    });

    it(@"displays header only", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.headerSize = CGSizeMake(0, 10);
        viewController.colorCount = 0;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalHeaderOnly");
        expect(layout.collectionViewContentSize.height).to.equal(10);
    });

    it(@"displays header and footer", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.headerSize = CGSizeMake(0, 30);
        viewController.footerSize = CGSizeMake(0, 5);
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalWithHeaderAndFooter");
        expect(layout.collectionViewContentSize.height).to.equal(135);
    });
});

describe(@"trailing layout", ^{
    __block ARCollectionViewController *viewController = nil;

    beforeEach(^{
        layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
        viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 4;
    });

    it(@"allows an entry to the right to stick out if it sticks out <= 50% of its height", ^{
        viewController.heightPerEntry = @[@(100), @(150), @(100), @(100)];
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"trailingStickingOut");
    });

    xit(@"moves an entry to the left if it would normally be at the right and stick out from the rest by more than 50% of its height", ^{
        viewController.heightPerEntry = @[@(100), @(151), @(100), @(100)];
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).recordSnapshotNamed(@"trailingMoveToLeft");
    });
});

describe(@"longestDimensionWithLengths", ^{
    beforeEach(^{
        layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionHorizontal];
    });
    
    it(@"returns zero without a view", ^{
        expect([layout longestDimensionWithLengths:@[] withOppositeDimension:0]).to.equal(0);
    });
});

SpecEnd
