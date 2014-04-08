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
    
    describe(@"unit tests", ^{
        it(@"should have default values when initialized", ^{
            ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionHorizontal];
            
            expect(layout.rank).to.equal(2);
            expect(layout.dimensionLength).to.equal(120);
            expect(layout.contentInset).to.equal(UIEdgeInsetsZero);
            expect(layout.itemMargins).to.equal(CGSizeZero);
        });
        
        it (@"should have correct direction when initialized", ^{
            ARCollectionViewMasonryLayout *horizontalLayout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionHorizontal];
            
            expect(horizontalLayout.direction).to.equal(ARCollectionViewMasonryLayoutDirectionHorizontal);
            
            ARCollectionViewMasonryLayout *verticalLayout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
            
            expect(verticalLayout.direction).to.equal(ARCollectionViewMasonryLayoutDirectionVertical);
        });
    });
    
    describe(@"screenshots", ^{
        beforeAll(^{
            setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
        });
        
        describe(@"horiztonal", ^{
            pending(@"displays", ^{
                ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionHorizontal];
                ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
                
                expect(viewController.view).willNot.beNil();
                expect(viewController.view).to.haveValidSnapshotNamed(@"horizontal");
            });
        });
        
        describe(@"vertical", ^{
            pending(@"displays", ^{
                ARCollectionViewMasonryLayout *layout = [[ARCollectionViewMasonryLayout alloc] initWithDirection:ARCollectionViewMasonryLayoutDirectionVertical];
                ARCollectionViewController *viewController = [[ARCollectionViewController alloc] initWithCollectionViewLayout:layout];
                
                expect(viewController.view).willNot.beNil();
                expect(viewController.view).to.haveValidSnapshotNamed(@"vertical");
            });
        });
    });
});

SpecEnd
