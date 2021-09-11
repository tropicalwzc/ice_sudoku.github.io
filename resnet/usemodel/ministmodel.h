//
//  ministmodel.h
//  ice sudoku
//
//  Created by 王子诚 on 2021/9/2.
//  Copyright © 2021 王子诚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IceSudokuModel.h"

#ifndef ministmodel_h
#define ministmodel_h

API_AVAILABLE(ios(13.0))
@interface ministmodel: NSObject
{
    IceSudokuModel* our_resnet;
}
-(ministmodel*)init;
-(int)PredictWithInputimage:(UIImage*)input_img;
@end
#endif /* ministmodel_h */
