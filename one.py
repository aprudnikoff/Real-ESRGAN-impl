import os 
import torch
from PIL import Image
import numpy as np
from RealESRGAN import RealESRGAN

def main(input_image_path: str, output_image_path: str) -> int:
    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    model = RealESRGAN(device, scale=4)
    model.load_weights('weights/RealESRGAN_x4.pth', download=True)

    # Process the single input image and save the output
    image = Image.open(input_image_path).convert('RGB')
    sr_image = model.predict(image)
    sr_image.save(output_image_path)

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 3:
        print('Usage: python3 main.py <input_image_path> <output_image_path>')
        sys.exit(1)
    
    input_image_path = sys.argv[1]
    output_image_path = sys.argv[2]
    main(input_image_path, output_image_path)
