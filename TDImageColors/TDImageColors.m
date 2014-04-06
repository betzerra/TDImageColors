//
//  TDImageColors.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "TDImageColors.h"

#define TDIMAGECOLORS_SCALED_SIZE 100

@interface TDCountedColor : NSObject

@property (assign) NSUInteger count;
@property (strong) UIColor *color;

- (id)initWithColor:(UIColor *)color count:(NSUInteger)count;

@end

@interface TDImageColors ()

@end

@implementation TDImageColors

#pragma mark - Private

- (NSCountedSet *)allColorsFromUIImage:(UIImage *)anImage{
    
    size_t width = CGImageGetWidth(anImage.CGImage);
    size_t height = CGImageGetHeight(anImage.CGImage);
    
    NSCountedSet *retVal = [[NSCountedSet alloc] initWithCapacity:width * height];
    
    for (NSUInteger x = 0; x < width; x++) {
        for (NSUInteger y = 0; y < height; y++) {
            UIColor *color = [UIImage colorFromImage:anImage atX:x andY:y];
            [retVal addObject:color];
        }
    }
    
    return retVal;
}

#pragma mark - Public

- (id)initWithImage:(UIImage *)image count:(NSUInteger)count {
  if ((self = [super init])) {
    _count = count;
    _colors = @[];
    _scaledImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(TDIMAGECOLORS_SCALED_SIZE,
                                                                         TDIMAGECOLORS_SCALED_SIZE)];
    [self detectColorsFromImage:_scaledImage];
  }
  return self;
}

- (void)detectColorsFromImage:(UIImage *)image {
    if (image){
        //  Get colors
        NSMutableArray *finalColors = [NSMutableArray array];
        [finalColors addObjectsFromArray:[self findColorsOfImage:image]];
        
        //  If colors are not enough add white color?
        while (finalColors.count < _count){
            [finalColors addObject:[UIColor whiteColor]];
        }
        
        _colors = [NSArray arrayWithArray:finalColors];
    }
}

- (NSArray *)findColorsOfImage:(UIImage *)image{
    NSCountedSet *imageColors = [self allColorsFromUIImage:image];
  
    NSEnumerator *enumerator = [imageColors objectEnumerator];
    UIColor *curColor = nil;
    NSMutableArray *sortedColors = [NSMutableArray arrayWithCapacity:imageColors.count];
    NSMutableArray *resultColors = [NSMutableArray array];

    while ((curColor = [enumerator nextObject]) != nil) {
        curColor = [curColor colorWithMinimumSaturation:0.15f];
        NSUInteger colorCount = [imageColors countForObject:curColor];
        [sortedColors addObject:[[TDCountedColor alloc] initWithColor:curColor count:colorCount]];
    }

    [sortedColors sortUsingSelector:@selector(compare:)];

    for (TDCountedColor *countedColor in sortedColors) {
        curColor = countedColor.color;
        BOOL continueFlag = NO;
        
        for (UIColor *c in resultColors) {
            if (![curColor isDistinct:c]) {
                continueFlag = YES;
                break;
            }
        }
        
        if (continueFlag)
            continue;
        if (resultColors.count < _count){
            [resultColors addObject:curColor];
        }else{
            break;
        }
    }
    
    NSArray *retVal = [NSArray arrayWithArray:resultColors];
    return retVal;
}

@end

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
    float red = 0;
    float green = 0;
    float blue = 0;
    float alpha = 0;
    
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSString *retVal = [NSString stringWithFormat:@"%@ R:%.0f G:%.0f B:%.0f A:%.0f (count %d)",
                                                                                [super description],
                                                                                red * 255,
                                                                                green * 255,
                                                                                blue * 255,
                                                                                alpha * 255,
                                                                                self.count];
    return retVal;
}


@end
