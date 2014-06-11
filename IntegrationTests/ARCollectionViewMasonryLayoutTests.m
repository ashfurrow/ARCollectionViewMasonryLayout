//
//  ARCollectionViewMasonryLayoutTests.m
//  Demo
//
//  Created by Ash Furrow on 2014-04-07.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARCollectionViewMasonryLayout.h"
#import "ARCollectionViewController.h"
#import "ARCollectionViewReusableView.h"

SpecBegin(ARCollectionViewMasonryLayoutTests)

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
    });
    
    it (@"has the correct horizontal direction", ^{
        expect(layout.direction).to.equal(ARCollectionViewMasonryLayoutDirectionHorizontal);
    });
    
    it(@"displays cells", ^{
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 5;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontal");
    });
    
    it(@"displays footer", ^{
        layout.footerHeight = 20;
        layout.footerViewClass = [ARCollectionViewReusableView class];
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 7;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalWithFooter");
    });
    
    it(@"displays header", ^{
        layout.headerHeight = 10;
        layout.headerViewClass = [ARCollectionViewReusableView class];
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalWithHeader");
    });

    it(@"displays header and footer", ^{
        layout.headerHeight = 3;
        layout.footerHeight = 5;
        layout.headerViewClass = [ARCollectionViewReusableView class];
        layout.footerViewClass = [ARCollectionViewReusableView class];
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"horizontalWithHeaderAndFooter");
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
    });

    it(@"displays footer", ^{
        layout.footerHeight = 20;
        layout.footerViewClass = [ARCollectionViewReusableView class];
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 7;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalWithFooter");
    });

    it(@"displays header", ^{
        layout.headerHeight = 10;
        layout.headerViewClass = [ARCollectionViewReusableView class];
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalWithHeader");
    });
    
    it(@"displays header and footer", ^{
        layout.headerHeight = 30;
        layout.footerHeight = 5;
        layout.headerViewClass = [ARCollectionViewReusableView class];
        layout.footerViewClass = [ARCollectionViewReusableView class];
        ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
        viewController.colorCount = 4;
        expect(viewController.view).willNot.beNil();
        expect(viewController.view).will.haveValidSnapshotNamed(@"verticalWithHeaderAndFooter");
    });
});

SpecEnd
