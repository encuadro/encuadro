//
//  CuadroTableViewCell.m
//  TableViewStory
//
//  Created by encuadro augmented reality on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CuadroTableViewCell.h"

@implementation CuadroTableViewCell

@synthesize autorLabel = _autorLabel;
@synthesize obraLabel = _obraLabel;
@synthesize cuadroImage = _cuadroImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
