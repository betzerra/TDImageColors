//
//  TDImageColors.m
//  TDImageColors
//
//  Created by timominous on 11/22/13.
//  Copyright (c) 2013 timominous. All rights reserved.
//

#import "TDImageColors.h"

#define TDIMAGECOLORS_SCALED_SIZE 100

typedef struct RGBAPixel
{
    Byte red;
    Byte green;
    Byte blue;
    Byte alpha;
    
} RGBAPixel;

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
    
    CGImageRef imageRep = anImage.CGImage;
    
    NSInteger width = CGImageGetWidth(imageRep);
    NSInteger height = CGImageGetHeight(imageRep);
    
    NSCountedSet *retVal = [[NSCountedSet alloc] initWithCapacity:width * height];
    
    CGImageRef imageRef = anImage.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow,
                                                 colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);

    
    // rawDara now contains the image data in RGBA8888
    
    for (NSUInteger x = 0; x < width; x++) {
        for (NSUInteger y = 0; y < height; y++) {
            
            int byteIndex = (bytesPerRow * y) + (x * bytesPerPixel);
            
            CGFloat red = (rawData[byteIndex] * 1.f) / 255.f;
            CGFloat green = (rawData[byteIndex + 1] * 1.f) / 255.f;
            CGFloat blue = (rawData[byteIndex + 2] * 1.f) / 255.f;
            CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.f;
            
            UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            [retVal addObject:color];
        }
    }

    CGContextRelease(context);
    free(rawData);
    
    return retVal;
}

#pragma mark - Public

- (id)initWithImage:(UIImage *)image count:(NSUInteger)count threshold:(CGFloat)threshold{
    if ((self = [super init])) {
        NSDate *beginDate = [NSDate date];
        
        _count = count;
        _colors = @[];
        _scaledImage = [UIImage imageWithImage:image scaledToSize:CGSizeMake(TDIMAGECOLORS_SCALED_SIZE,
                                                                           TDIMAGECOLORS_SCALED_SIZE)];
        _threshold = threshold;
        [self detectColorsFromImage:_scaledImage];
        
        NSLog(@"#DEBUG time ellapsed %.2f", [beginDate timeIntervalSinceNow]);
    }
    return self;
}

- (void)detectColorsFromImage:(UIImage *)image {
    if (image){
        //  Get colors
        NSMutableArray *finalColors = [NSMutableArray array];
        [finalColors addObjectsFromArray:[self findColorsOfImage:image]];
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
            if (![curColor isDistinct:c threshold:_threshold]) {
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
