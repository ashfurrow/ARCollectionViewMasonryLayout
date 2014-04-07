//
//  ARCollectionViewMasonryLayoutTests.m
//  Demo
//
//  Created by Ash Furrow on 2014-04-07.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARCollectionViewMasonryLayout.h"
#import "ARCollectionViewController.h"

#define EXP_SHORTHAND
#import <Specta/Specta.h>
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <EXPMatchers+FBSnapshotTest/EXPMatchers+FBSnapshotTest.h>

SpecBegin(ARCollectionViewMasonryLayoutTests)

describe(@"ARCollectionViewMasonryLayout", ^{
    
    beforeAll(^{
        setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
    });
    
    describe(@"horiztonal", ^{
        it(@"displays", ^{
            ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionHorizontal];
            ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
            
            expect(viewController.view).willNot.beNil();
            expect(viewController.view).to.haveValidSnapshotNamed(@"horizontal");
        });
    });
    
    describe(@"vertical", ^{
        it(@"displays", ^{
            ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
            ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
            
            expect(viewController.view).willNot.beNil();
            expect(viewController.view).to.haveValidSnapshotNamed(@"vertical");
        });
    });
});

SpecEnd
