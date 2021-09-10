import coremltools as ct
from coremltools.models.neural_network import quantization_utils

model_fp32 = ct.models.MLModel('IceSudokuModelFull.mlmodel')

model_fp16 = quantization_utils.quantize_weights(model_fp32, nbits=16)

model_fp16.save("IceSudokuModel.mlmodel")
