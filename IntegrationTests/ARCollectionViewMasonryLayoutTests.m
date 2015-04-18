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

@interface _ARCollectionViewMasonryAttributesGrid (Private)
@property (nonatomic, readonly, strong) NSArray *sections;
@end

static void
AddLayoutAttributesToSectionWithHeight(_ARCollectionViewMasonryAttributesGrid *grid,
                                       NSUInteger sectionIndex,
                                       CGFloat height) {
    static CGFloat width = 100;
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes new];
    attributes.size = CGSizeMake(width, height);
    [grid addAttributes:attributes toSection:sectionIndex];
}

SpecBegin(ARCollectionViewMasonryLayoutTests)

describe(@"_ARCollectionViewMasonryAttributesGrid", ^{
    __block _ARCollectionViewMasonryAttributesGrid *grid = nil;

    beforeEach(^{
        grid = [[_ARCollectionViewMasonryAttributesGrid alloc] initWithSectionCount:3
                                                                          direction:ARCollectionViewMasonryLayoutDirectionVertical
                                                                       leadingInset:0
                                                                    orthogonalInset:0
                                                                     mainItemMargin:0
                                                                alternateItemMargin:0
                                                                    centeringOffset:0];
    });

    it(@"creates a list of empty sections", ^{
        expect(grid.sections.count).to.equal(3);
        expect([grid.sections[0] count]).to.equal(0);
        expect([grid.sections[1] count]).to.equal(0);
        expect([grid.sections[2] count]).to.equal(0);
    });

    it(@"adds item attributes to the grid", ^{
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes new];
        attributes.size = CGSizeMake(100, 100);
        [grid addAttributes:attributes toSection:0];
        expect([grid attributesAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]).to.equal(attributes);

        expect([grid.sections[0] count]).to.equal(1);
        expect([grid.sections[1] count]).to.equal(0);
        expect([grid.sections[2] count]).to.equal(0);
    });

    describe(@"with items in each section", ^{
        beforeEach(^{
            AddLayoutAttributesToSectionWithHeight(grid, 0, 10);
            AddLayoutAttributesToSectionWithHeight(grid, 0, 10);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 20);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 20);
            AddLayoutAttributesToSectionWithHeight(grid, 2, 30);
            AddLayoutAttributesToSectionWithHeight(grid, 2, 30);
        });

        it(@"returns the total dimension for a section (in the configured direction)", ^{
            expect([grid dimensionForSection:0]).to.equal(20);
            expect([grid dimensionForSection:1]).to.equal(40);
            expect([grid dimensionForSection:2]).to.equal(60);
        });

        it(@"returns what the shortest section is", ^{
            expect(grid.shortestSection).to.equal(0);
            AddLayoutAttributesToSectionWithHeight(grid, 0, 100);
            expect(grid.shortestSection).to.equal(1);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 100);
            expect(grid.shortestSection).to.equal(2);
        });

        it(@"returns the longest section's dimension", ^{
            expect(grid.longestSectionDimension).to.equal(60);  // section 2
            AddLayoutAttributesToSectionWithHeight(grid, 0, 100);
            expect(grid.longestSectionDimension).to.equal(120); // section 0
            AddLayoutAttributesToSectionWithHeight(grid, 1, 100);
            expect(grid.longestSectionDimension).to.equal(140); // section 1
        });
    });

    describe(@"concerning trailing items", ^{
        it(@"allows an entry to stick out if it sticks out <= 50% of its height compared to the shortest section in front of it", ^{
            AddLayoutAttributesToSectionWithHeight(grid, 0, 100);
            AddLayoutAttributesToSectionWithHeight(grid, 0, 100);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 105);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 100);
            AddLayoutAttributesToSectionWithHeight(grid, 2, 150);
            AddLayoutAttributesToSectionWithHeight(grid, 2, 100);

            [grid ensureTrailingItemsDoNotStickOut];
            expect([grid dimensionForSection:0]).to.equal(200);
            expect([grid dimensionForSection:1]).to.equal(205);
            expect([grid dimensionForSection:2]).to.equal(250);
        });

        it(@"moves an entry to the front if it would stick out by more than 50% of its height compared to the shortest section in front of it", ^{
            AddLayoutAttributesToSectionWithHeight(grid, 0, 100);
            AddLayoutAttributesToSectionWithHeight(grid, 0, 100);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 105);
            AddLayoutAttributesToSectionWithHeight(grid, 1, 100);
            AddLayoutAttributesToSectionWithHeight(grid, 2, 151);
            AddLayoutAttributesToSectionWithHeight(grid, 2, 100);

            [grid ensureTrailingItemsDoNotStickOut];
            expect([grid dimensionForSection:0]).to.equal(300);
            expect([grid dimensionForSection:1]).to.equal(205);
            expect([grid dimensionForSection:2]).to.equal(151);
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
        expect(layout.collectionViewContentSize.width).to.equal(150);
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

    it(@"moves an entry to the left if it would normally be at the right and stick out from the rest by more than 50% of its height", ^{
        viewController.heightPerEntry = @[@(100), @(151), @(100), @(100)];
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"trailingMoveToLeft");
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
