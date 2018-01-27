//
//  LookupFilter16.m
//  MagicCamera
//
//  Created by SuGuocai on 2018/1/27.
//  Copyright © 2018年 sugc. All rights reserved.
//

#import "LookupFilter16.h"

@interface LookupFilter16()

@end

@implementation LookupFilter16

- (instancetype)init {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lookup16Fragment" ofType:@"glsl"];
    NSString *str = [NSString stringWithContentsOfFile:path];
    
    self = [super initWithFragmentShaderFromString:str];
    
    if (self) {
        
    }
    return self;
}

- (void)setLookupImage:(GPUImagePicture *)lookupImage {
    _lookupImage = lookupImage;
    [_lookupImage addTarget:self atTextureLocation:1];
    [_lookupImage processImage];
}

@end
