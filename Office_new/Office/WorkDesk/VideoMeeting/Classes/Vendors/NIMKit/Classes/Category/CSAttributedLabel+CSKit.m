//
//  CSAttributedLabel+CSKit
//  NIM
//
//  Created by chris.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "CSAttributedLabel+CSKit.h"
#import "CSInputEmoticonParser.h"
#import "CSInputEmoticonManager.h"

@implementation CSAttributedLabel (CSKit)
- (void)cs_setText:(NSString *)text
{
    [self setText:@""];
    NSArray *tokens = [[CSInputEmoticonParser currentParser] tokens:text];
    for (CSInputTextToken *token in tokens)
    {
        if (token.type == NIMInputTokenTypeEmoticon)
        {
            CSInputEmoticon *emoticon = [[CSInputEmoticonManager sharedManager] emoticonByTag:token.text];
            UIImage *image = [UIImage imageNamed:emoticon.filename];
            if (image)
            {
                [self appendImage:image
                          maxSize:CGSizeMake(18, 18)];
            }
        }
        else
        {
            NSString *text = token.text;
            [self appendText:text];
        }
    }
}
@end
