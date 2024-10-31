import os 
import time
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
    sr_image.save(output_image_path, 'jpeg', quality=95)

if __name__ == '__main__':
    import sys
    if len(sys.argv) != 3:
        print('Usage: python3 main.py <input_image_path> <output_image_path>')
        sys.exit(1)
    
    input_image_path = sys.argv[1]
    output_image_path = sys.argv[2]
        
    start_time = time.time()
    main(input_image_path, output_image_path)
    end_time = time.time()
    execution_time = round(end_time - start_time)
    print(f'Execution time: ~{execution_time} seconds')

# /usr/local/lib/python3.10/dist-packages/huggingface_hub/utils/_deprecation.py:131: FutureWarning: 'cached_download' (from 'huggingface_hub.file_download') is deprecated and will be removed from version '0.26'. Use `hf_hub_download` instead.
#   warnings.warn(warning_message, FutureWarning)
# /usr/local/lib/python3.10/dist-packages/huggingface_hub/file_download.py:672: FutureWarning: 'cached_download' is the legacy way to download files from the HF hub, please consider upgrading to 'hf_hub_download'
#   warnings.warn(