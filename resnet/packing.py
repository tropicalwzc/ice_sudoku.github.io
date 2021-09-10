import torch
import coremltools as ct
import torch.nn as nn
from resnet import resnet34
from prune import export_new_model

DEVICE = torch.device("cuda" if torch.cuda.is_available() else "cpu")

def transfer_to_coreml():

    # modelorg = torch.load('current_bestquick.pth')
    # modelc = export_new_model(modelorg)
    # print(modelc.keys())
    # print(modelc['state_dict'])
    # print(checkpoint['cfg'])
    # print(checkpoint['state_dict'])
    # modelc = resnet34(cfg=checkpoint['cfg'])
    # modelc.load_state_dict(checkpoint)
    # modelc = modelc.cuda()
    # print(modelc)
    # Create dummy input

    modelc = torch.load('current_best.pth')
    modelc = modelc.half()
    modelc = modelc.cuda()

    dummy_input = torch.rand(1, 3, 64, 64)
    dummy_input = dummy_input.half()
    dummy_input = dummy_input.to(DEVICE)
    # Trace the model
    traced_model = torch.jit.trace(modelc, dummy_input)
    # Create the input image type
    input_image = ct.ImageType(name="my_input", shape=(1, 3, 64, 64), scale=1 / 255)

    # Convert the model
    coreml_model = ct.convert(traced_model, inputs=[input_image])
    coreml_model.author = '王子诚'
    # Modify the output's name to "my_output" in the spec
    spec = coreml_model.get_spec()
    spec.description.metadata.shortDescription = "ice sudoku identify model designed by Tropical fish"
    ct.utils.rename_feature(spec, "1154", "my_output")

    # Re-create the model from the updated spec
    coreml_model_updated = ct.models.MLModel(spec)
    # Save the CoreML model
    coreml_model_updated.save('IceSudokuModelFull.mlmodel')

if __name__ == '__main__':
    transfer_to_coreml()
