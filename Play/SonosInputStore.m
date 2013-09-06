//
//  SonosInputStore.m
//  Play
//
//  Created by Nathan Borror on 1/1/13.
//  Copyright (c) 2013 Nathan Borror. All rights reserved.
//

#import "SonosInputStore.h"
#import "SonosInput.h"

@implementation SonosInputStore {
  NSMutableArray *inputList;
}

- (id)init
{
  if (self = [super init]) {
    NSString *path = [self inputArchivePath];
    inputList = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!inputList) {
      inputList = [[NSMutableArray alloc] init];
    }
  }
  return self;
}

+ (SonosInputStore *)sharedStore
{
  static SonosInputStore *inputStore = nil;
  if (!inputStore) {
    inputStore = [[SonosInputStore alloc] init];
  }
  return inputStore;
}

- (NSArray *)allInputs
{
  return inputList;
}

- (SonosInput *)inputAtIndex:(NSUInteger)index
{
  return [inputList objectAtIndex:index];
}

- (SonosInput *)inputWithUid:(NSString *)uid
{
  for (SonosInput *input in inputList) {
    if ([input.uid isEqual:uid]) {
      return input;
    }
  }
  return nil;
}

- (SonosInput *)addInputWithIP:(NSString *)aIP name:(NSString *)aName uid:(NSString *)aUid icon:(UIImage *)aIcon
{
  SonosInput *input = [[SonosInput alloc] initWithIP:aIP name:aName uid:aUid icon:aIcon];
  [inputList addObject:input];
  return input;
}

- (void)removeInput:(SonosInput *)input
{
  [inputList removeObjectIdenticalTo:input];
}

#pragma mark - NSCoding

- (NSString *)inputArchivePath
{
  NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [documentDirectories objectAtIndex:0];
  return [documentDirectory stringByAppendingPathComponent:@"inputs.archive"];
}

- (BOOL)saveChanges
{
  NSString *path = [self inputArchivePath];
  return [NSKeyedArchiver archiveRootObject:inputList toFile:path];
}

@end
