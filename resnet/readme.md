### 1. 需要准备好Merge和Coloring这2个数据集，可以使用minist随机生成1-9，还需要收集各种各样数独的截图，例如SudokuDataSet.zip里面有ice sudoku相关的截图，其他App的也尽可能收集到数据集里面

#### Prepare Merge and Coloring datasets. You can use minist random generator for number 1-9. You need collect as many images as possible like SudokuDataSet.zip which contains ice sudoku dataset.

### 2. 训练时需要根据你的显卡调整参数，目前使用的参数是给6GB显存的3060显卡使用的, 直接运行 `mainrunner.py` 即可开始训练，最佳模型会存储到current_best.pth中

#### You have to adjust the parameters before training , the default parameters are designed for Nvidia 3060 6GB. Just running `mainrunner.py` then you can get the best model at current_best.pth

### 3. 训练完成之后运行`packing.py` 自动将pytorch模型转换为coreml格式
#### after training your model , run `packing.py`, it could transform pytorch model to coreml model.

### 4. 这一步需要在macOS上才能运行，运行`halfer.py`直接将模型大小减半，基本不损失任何精度，因为本来就是以float训练的
#### This step must be perform on macOS. run `halfer.py`, you can save 50% disk space of the model.

### 5. 将最终生成好的IceSudokuModel.mlmodel拖入Xcode项目内，引入头文件"IceSudokuModel.h"就可以方便的在OC里面调用机器学习模型了
#### Drag the final result IceSudokuModel.mlmodel to your Xcode project. include "IceSudokuModel.h" then you can run the model in Objective-C now .

### 6. 在usemodel文件夹内有Objective-C详细调用IceSudokuModel的实现，但是还需要开发一个扫描界面才能更好的使用，smart类只是提供了线程调度和智能调节识别结果的方法。
#### Of course that is still not enough, you need designing a scan view for users.



