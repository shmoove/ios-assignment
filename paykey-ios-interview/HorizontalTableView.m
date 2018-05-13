//
//  HorizontalScrollView.m
//  paykey-ios-interview
//
//  Created by Ishay Weinstock on 12/16/14.
//  Copyright (c) 2014 Ishay Weinstock. All rights reserved.
//

#import "HorizontalTableView.h"

#define SEPARATOR_WIDTH 1
#define DEFAULT_CELL_WIDTH 100

@implementation HorizontalTableView

// private
CGFloat xOffset;
NSMutableArray *usedCells;
NSMutableArray *freeCells;

// cellWidth property
@synthesize cellWidth = _cellWidth;

- (void) setCellWidth: (CGFloat)cw{
	_cellWidth = cw;
	[self setNeedsDisplay]; // force refresh
}

- (CGFloat) cellWidth{
	if (!_cellWidth) {
		return DEFAULT_CELL_WIDTH;
	}
	else {
		return _cellWidth;
	}
}

// dataSource property
@synthesize dataSource = _dataSource;

- (void) setDataSource: (id<HorizontalTableViewDataSource>)ds{
	_dataSource = ds;
	[self setNeedsDisplay]; // force refresh
}

- (CGFloat) dataSource{
	return _dataSource;
}

// public methods
- (UIView*)dequeueCell{
	UIView* result = nil;
	int freeCount = [freeCells count];
	if (freeCount > 0)
	{
		// pop a free cell
		result = [freeCells lastObject];
		[freeCells removeLastObject];
	}
    return result;
}

// override UIView methods
-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        xOffset = 0;
		usedCells = [NSMutableArray arrayWithCapacity:1];
		freeCells = [NSMutableArray arrayWithCapacity:1];
    }

    return self;
}

- (void)drawRect:(CGRect)rect{
	if (self.dataSource)
	{
		// remove old cells
		while ([usedCells count] > 0)
		{
			// pop it from used, push it to free, and remove the subview
			UIView* cell = [usedCells lastObject];
			[usedCells removeLastObject];
			[freeCells addObject:cell];
			[cell removeFromSuperView];
		}
	
		int numberOfCells = (int)[self.datasource horizontalTableViewNumberOfCells: self];
		
		CGFloat cellWidth = self.cellWidth + SEPARATOR_WIDTH;
		
		// relative start and end positions
		CGFloat from = xOffset;
		CGFloat to = from + rect.size.width;
		
		int currentCell = (int)(floor(from / cellWidth)); // first visible cell
		CGFloat currentPosition = from - (currentCell * cellWidth); // absolute position of the start of the first visible cell
		
		while (currentCell < numberOfCells && currentPosition < to)
		{
			// get the cell, add and position the view, and add it to used
			UIView* cell = [self.datasource horizontalTableView: self cellForIndex:currentCell];
			cell.frame = CGRectMake(currentPosition, 0, cell.frame.width, cell.frame.height);
			[self addSubView cell];
			[usedCells addObject:cell];
			++currentCell;
			currentPosition += cellWidth;
		}
	}
}

@end
