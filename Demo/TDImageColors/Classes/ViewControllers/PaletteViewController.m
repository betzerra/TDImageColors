//
//  PaletteViewController.m
//  TDImageColors
//
//  Created by Ezequiel A Becerra on 4/6/14.
//  Copyright (c) 2014 timominous. All rights reserved.
//

#import "PaletteViewController.h"

@interface PaletteViewController ()

@end

@implementation PaletteViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger retVal = [_colors count];
    return retVal;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UIColor *aColor = self.colors[indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellIdentifier"
                                                                    forIndexPath:indexPath];
    cell.backgroundColor = aColor;
    return cell;
}

@end
