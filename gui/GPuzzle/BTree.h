#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>


@interface BTree : NSObject
{
    BTree *first, *second, *parent;
    id leaf;
    int tag;
}

+ fromLines:(NSEnumerator *)en;

- initWithLeaf:(id)theLeaf;
- initWithPairFirst:(BTree *)fp andSecond:(BTree *)sp;

- leaf;
- (BTree *)first;
- (BTree *)second;
- (int)tag;

- setFirst:(BTree *)theFirst;
- setSecond:(BTree *)theSecond;

- setParent:(BTree *)theParent;
- parent;

- (BTree *)findLeaf:(id)theLeaf;

- (NSMutableArray *)leaves;

- inorderWithTarget:(id)t sel:(SEL)what;
- inorderWithPointer:(void *)ptr sel:(SEL)what;

- substituteLeaves:(NSMutableDictionary *)dict;

- (NSString *)toString;

- (void)deallocAll;

@end


