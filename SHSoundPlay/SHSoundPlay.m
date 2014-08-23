//
//  SHSoundPlay.m
//  MCSoundBoard
//
//  Created by 马远征 on 14-8-23.
//  Copyright (c) 2014年 MobileCreators. All rights reserved.
//

#import "SHSoundPlay.h"
#import <AudioToolbox/AudioToolbox.h>

#define MCSOUNDBOARD_AUDIO_FADE_STEPS   30

@interface SHSoundPlay()
{
   
}
@property (nonatomic, strong) NSMutableDictionary *soundsDic;
@property (nonatomic, strong) NSMutableDictionary *audioDic;
@end

@implementation SHSoundPlay
+ (id)shared
{
    static dispatch_once_t pred;
    static SHSoundPlay *sharedinstance = nil;
    dispatch_once(&pred, ^{ sharedinstance = [[self alloc] init]; });
    return sharedinstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (NSMutableDictionary*)soundsDic
{
    if (_soundsDic)
    {
        return _soundsDic;
    }
    _soundsDic = [NSMutableDictionary dictionary];
    return _soundsDic;
}

- (NSMutableDictionary*)audioDic
{
    if (_audioDic)
    {
        return _audioDic;
    }
    _audioDic = [NSMutableDictionary dictionary];
    return _audioDic;
}

- (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [self.audioDic objectForKey:key];
}

- (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    if (filePath == nil || key == nil)
    {
        return;
    }
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &soundId);
    
    [self.soundsDic setObject:[NSNumber numberWithInt:soundId] forKey:key];
}

- (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    if (filePath == nil || key == nil)
    {
        return;
    }
    NSURL* fileURL = [NSURL fileURLWithPath:filePath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    [self.audioDic setObject:player forKey:key];
}

- (void)removeSoundForKey:(id)key
{
    if (key == nil)
    {
        return;
    }
    [self.soundsDic removeObjectForKey:key];
}

- (void)removeAudioForKey:(id)key
{
    if (key == nil)
    {
        return;
    }
    [self.audioDic removeObjectForKey:key];
}

- (void)playSoundForKey:(id)key
{
    SystemSoundID soundId = [(NSNumber *)[self.soundsDic objectForKey:key] intValue];
    AudioServicesPlaySystemSound(soundId);
}

- (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval
{
    AVAudioPlayer *player = [self.audioDic objectForKey:key];
    if (fadeInInterval > 0.0)
    {
        player.volume = 0.0;
        NSTimeInterval interval = fadeInInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeIn:)
                                       userInfo:player
                                        repeats:YES];
    }
    
    [player play];
}

- (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    AVAudioPlayer *player = [self.audioDic objectForKey:key];
    
    if (fadeOutInterval > 0)
    {
        NSTimeInterval interval = fadeOutInterval / MCSOUNDBOARD_AUDIO_FADE_STEPS;
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOutAndStop:)
                                       userInfo:player
                                        repeats:YES];
    }
    else
    {
        [player stop];
    }
}

- (void)fadeIn:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume + 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume > 1.0 ? 1.0 : volume;
    player.volume = volume;
    
    if (volume == 1.0)
    {
        [timer invalidate];
    }
}

- (void)fadeOutAndStop:(NSTimer *)timer
{
    AVAudioPlayer *player = timer.userInfo;
    float volume = player.volume;
    volume = volume - 1.0 / MCSOUNDBOARD_AUDIO_FADE_STEPS;
    volume = volume < 0.0 ? 0.0 : volume;
    player.volume = volume;
    
    if (volume == 0.0)
    {
        [timer invalidate];
        [player pause];
    }
}

#pragma mark -
#pragma mark class factory

+ (AVAudioPlayer *)audioPlayerForKey:(id)key
{
    return [[self shared] audioPlayerForKey:key];
}

+ (void)addSoundAtPath:(NSString *)filePath forKey:(id)key
{
    [[self shared] addSoundAtPath:filePath forKey:key];
}

+ (void)addAudioAtPath:(NSString *)filePath forKey:(id)key
{
    [[self shared] addAudioAtPath:filePath forKey:key];
}

+ (void)removeSoundForKey:(id)key
{
    [[self shared]removeSoundForKey:key];
}

+ (void)removeAudioForKey:(id)key
{
    [[self shared]removeAudioForKey:key];
}

+ (void)playSoundForKey:(id)key
{
    [[self shared] playSoundForKey:key];
}

+ (void)playAudioForKey:(id)key
{
    [[self shared] playAudioForKey:key fadeInInterval:0.0];
}

+ (void)pauseAudioForKey:(id)key
{
    [[self shared] pauseAudioForKey:key fadeOutInterval:0.0];
}

+ (void)stopAudioForKey:(id)key
{
    [[self shared] stopAudioForKey:key fadeOutInterval:0.0];
}

+ (void)playAudioForKey:(id)key fadeInInterval:(NSTimeInterval)fadeInInterval
{
    [[self shared] playAudioForKey:key fadeInInterval:fadeInInterval];
}

+ (void)stopAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self shared] stopAudioForKey:key fadeOutInterval:fadeOutInterval];
}

+ (void)pauseAudioForKey:(id)key fadeOutInterval:(NSTimeInterval)fadeOutInterval
{
    [[self shared] pauseAudioForKey:key fadeOutInterval:fadeOutInterval];
}

@end
