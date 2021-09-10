### 1. 需要准备好Merge和Coloring这2个数据集，可以使用minist随机生成1-9，还需要收集各种各样数独的截图，例如SudokuDataSet.zip里面有ice sudoku相关的截图，其他App的也尽可能收集到数据集里面

### 2. 训练时需要根据你的显卡调整参数，目前使用的参数是给6GB显存的3060显卡使用的, 直接运行 `mainrunner.py` 即可开始训练，最佳模型会存储到current_best.pth中

### 3. 训练完成之后运行`packing.py` 自动将pytorch模型转换为coreml格式

### 4. 这一步需要在macOS上才能运行，运行`halfer.py`直接将模型大小减半，基本不损失任何精度，因为本来就是以float训练的
