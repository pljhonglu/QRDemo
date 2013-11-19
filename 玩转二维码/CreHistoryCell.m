//
//  CreHistoryCell.m
//  玩转二维码
//
//  Created by pljhonglu on 13-11-14.
//  Copyright (c) 2013年 pljhonglu. All rights reserved.
//

#import "CreHistoryCell.h"

@implementation CreHistoryCell
{
    UIImageView *_imageView;
    UILabel *_titleLable;
    UILabel *_content;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
        
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 20)];
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.backgroundColor = [UIColor clearColor];
        
        _content = [[UILabel alloc]initWithFrame:CGRectMake(50, 30, 250, 15)];
        _content.font = [UIFont systemFontOfSize:13];
        _content.textColor = [UIColor grayColor];
        _content.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_titleLable];
        [self.contentView addSubview:_content];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)bundingData:(DataModel *)model{
//    NSData *data = [NSData dataWithContentsOfFile:model.imagePath];
    
    UIImage *image = model.image;
    _imageView.image = image;
    
    _titleLable.text = model.type;
    _content.text = model.content;
}

@end
