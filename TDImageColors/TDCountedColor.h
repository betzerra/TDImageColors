//
//  TDCountedColor.h
//  TDImageColors
//
//  Created by Ezequiel Becerra on 4/5/15.
//  Copyright (c) 2015 timominous. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDCountedColor : NSObject

@property (assign) NSUInteger count;
@property (strong) UIColor *color;

- (id)initWithColor:(UIColor *)color count:(NSUInteger)count;

@end