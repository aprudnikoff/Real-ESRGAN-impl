import os 
import torch
from PIL import Image
import numpy as np
from RealESRGAN import RealESRGAN

# Get the absolute path of the directory containing main.py
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the input and output directories relative to main.py location
input_dir = os.path.join(script_dir, 'inputs')
output_dir = os.path.join(script_dir, 'results')

# Ensure the output directory exists
os.makedirs(output_dir, exist_ok=True)


def main() -> int:
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model = RealESRGAN(device, scale=4)
    model.load_weights('weights/RealESRGAN_x4.pth', download=True)
    for i, image_name in enumerate(os.listdir(input_dir)):
        image_path = os.path.join(input_dir, image_name)
        image = Image.open(image_path).convert('RGB')
        sr_image = model.predict(image)
        output_path = os.path.join(output_dir, f'{i}.png')
        sr_image.save(output_path)


if __name__ == '__main__':
    main()