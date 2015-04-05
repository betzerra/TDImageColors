//
//  TDCountedColor.m
//  TDImageColors
//
//  Created by Ezequiel Becerra on 4/5/15.
//  Copyright (c) 2015 timominous. All rights reserved.
//

#import "TDCountedColor.h"

@implementation TDCountedColor

- (id)initWithColor:(UIColor *)color count:(NSUInteger)count {
    if ((self = [super init])) {
        self.color = color;
        self.count = count;
    }
    return self;
}

- (NSComparisonResult)compare:(TDCountedColor *)object {
    if ([object isKindOfClass:[TDCountedColor class]]) {
        if (self.count < object.count)
            return NSOrderedDescending;
        else if (self.count == object.count)
            return NSOrderedSame;
    }
    return NSOrderedAscending;
}

- (NSString *)description{
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 0;
    
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSString *retVal = [NSString stringWithFormat:@"%@ R:%.0f G:%.0f B:%.0f A:%.0f (count %ld)",
                        [super description],
                        red * 255,
                        green * 255,
                        blue * 255,
                        alpha * 255,
                        self.count];
    return retVal;
}


@end
