
#import "BTree.h"

@interface BTree (Private)

- (NSString *)toStringData;

@end

@implementation BTree

static int count = 0;
static NSString *BTreeMark = @"@endtree";

+ fromLines:(NSEnumerator *)en
{
    NSMutableDictionary *dict = 
        [NSMutableDictionary dictionaryWithCapacity:1];
    NSScanner *scanner;
    NSString *line;
    int valtag, valfirst, valsecond, valleaf;
    BTree *current, *desc;
    NSEnumerator *objEn;
    
    while((line = [en nextObject])!=nil &&
          [line hasPrefix:BTreeMark]==NO){
        scanner = [NSScanner scannerWithString:line];
        if([scanner scanInt:&valtag]==NO ||
           [scanner scanInt:&valfirst]==NO ||
           [scanner scanInt:&valsecond]==NO ||
           [scanner scanInt:&valleaf]==NO){
            return nil;
        }

        current = 
            [[BTree alloc] 
                initWithLeaf:(valleaf==-1 ? 
                              nil : [NSNumber numberWithInt:valleaf])];
        [dict setObject:current forKey:
                  [NSNumber numberWithInt:valtag]];

        if(valfirst!=-1){
            desc = [dict objectForKey:[NSNumber numberWithInt:valfirst]];
            [current setFirst:desc];
        }
        if(valsecond!=-1){
            desc = [dict objectForKey:[NSNumber numberWithInt:valsecond]];
            [current setSecond:desc];
        }
    }

    return current;
}


- initWithLeaf:(id)theLeaf
{
    [super init];

    first = nil;
    second = nil;
    parent = nil;

    leaf = theLeaf;
    if(leaf!=nil){
        [leaf retain];
    }

    tag = count++;

    return self;
}

- initWithPairFirst:(BTree *)fp andSecond:(BTree *)sp
{
    [super init];

    first = fp;
    second = sp;
    if(first!=nil){
        [first setParent:self];
        [first retain];
    }
    if(second!=nil){
        [second setParent:self];
        [second retain];
    }

    leaf = nil;

    tag = count++;

    return self;
}

- (id)leaf
{
    return leaf;
}

- (BTree *)first
{
    return first;
}

- (BTree *)second
{
    return second;
}

- (int)tag
{
    return tag;
}

- setFirst:(BTree *)theFirst
{
    first = theFirst;
    if(first!=nil){
        [first setParent:self];
    }

    return self;
}

- setSecond:(BTree *)theSecond
{
    second = theSecond;
    if(second!=nil){
        [second setParent:self];
    }

    return self;
}


- setParent:(BTree *)theParent
{
    parent = theParent;
    return self;
}

- parent
{
    return parent;
}

- (BTree *)findLeaf:(id)theLeaf
{
    BTree *res;

    if(leaf==theLeaf){
        return self;
    }

    if(first!=nil && 
       ((res = [first findLeaf:theLeaf]) != nil)){
        return res;
    }
    if(second!=nil && 
       ((res = [second findLeaf:theLeaf]) != nil)){
        return res;
    }

    return nil;
}


- (NSMutableArray *)leaves
{
    NSMutableArray *data = 
        [NSMutableArray arrayWithCapacity:1];

    [self inorderWithTarget:data 
          sel:@selector(addObject:)];

    [data retain];
    return data;
}


- inorderWithTarget:(id)t sel:(SEL)what;
{
    if(first!=nil){
        [first inorderWithTarget:t sel:what];
    }

    if(leaf!=nil){
        IMP imp = [t methodForSelector:what];
        (*imp)(t, what, leaf);
    }

    if(second!=nil){
        [second inorderWithTarget:t sel:what];
    }

    return self;
}

- inorderWithPointer:(void *)ptr sel:(SEL)what
{
    if(first!=nil){
        [first inorderWithPointer:ptr sel:what];
    }

    if(leaf!=nil){
        IMP imp = [leaf methodForSelector:what];
        (*imp)(leaf, what, ptr);
    }

    if(second!=nil){
        [second inorderWithPointer:ptr sel:what];
    }

    return self;
}

- substituteLeaves:(NSMutableDictionary *)dict
{
    id obj;

    if(first!=nil){
        [first substituteLeaves:dict];
    }
    if(second!=nil){
        [second substituteLeaves:dict];
    }

    if(leaf!=nil && (obj=[dict objectForKey:leaf])!=nil){
        // NSLog(@"found %@ for %@\n", leaf, obj);
        leaf = obj;
    }
}

- (NSString *)toString
{
    return [[self toStringData]
               stringByAppendingFormat:@"%@\n", BTreeMark];
}


- (void)deallocAll
{
    if(first!=nil){
        [first deallocAll];
    }
    if(second!=nil){
        [second deallocAll];
    }

    [super dealloc];
}

@end

@implementation BTree (Private)

- (NSString *)toStringData
{
    NSString *node = @"", *res = @"";

    node = [node stringByAppendingFormat:@"%d ", tag];

    if(first!=nil){
        res = [res stringByAppendingString:
                       [first toStringData]];
        node = [node stringByAppendingFormat:@"%d ", 
                     [first tag]];
    }
    else{
        node = [node stringByAppendingString:@"-1 "];
    }
    if(second!=nil){
        res = [res stringByAppendingString:
                       [second toStringData]];
        node = [node stringByAppendingFormat:@"%d ", 
                     [second tag]];
    }
    else{
        node = [node stringByAppendingString:@"-1 "];
    }

    if(leaf!=nil){
        node = [node stringByAppendingFormat:@"%d", 
                     [leaf tag]];
    }
    else{
        node = [node stringByAppendingString:@"-1"];
    }

    res = [res stringByAppendingFormat:@"%@\n", node];
    return res;
}

@end
