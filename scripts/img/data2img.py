import argparse
from PIL import Image

def create_binary_image_from_file(input_file, width=None, pixel_size=10, output_file='binary_image.png'):
    """
    Creates an image from binary data stored in a file.
    
    Args:
        input_file (str): Path to the input file containing binary data.
        width (int): The number of pixels in each row. Defaults to a square layout.
        pixel_size (int): Size of each pixel in the image.
        output_file (str): Name of the output image file.
    """
    # Read binary data from the file
    with open(input_file, 'r') as file:
        data = ''.join(line.strip() for line in file)  # Concatenate all lines into one string
    
    # Validate the input data
    if not all(char in '01' for char in data):
        raise ValueError("The input file must contain only binary data (1s and 0s).")
    
    # Determine grid width and height
    if width is None:
        width = int(len(data)**0.5)  # Default to a square layout
    height = -(-len(data) // width)  # Ceiling division for height

    # Create a blank image
    img = Image.new("RGB", (width, height), "white")
    pixels = img.load()

    # Fill pixels with green for '1' and red for '0'
    for i, value in enumerate(data):
        x = i % width
        y = i // width
        color = (0, 255, 0) if value == '1' else (255, 0, 0)  # Green for 1, Red for 0
        pixels[x, y] = color

    # Resize the image to scale pixels
    img = img.resize((width * pixel_size, height * pixel_size), resample=Image.NEAREST)

    # Save the image
    img.save(output_file)
    print(f"Image saved as {output_file}")

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Generate an image from binary data (1s and 0s).")
    parser.add_argument('input_file', help="Path to the input file containing binary data.")
    parser.add_argument('--width', type=int, help="Number of pixels in each row. Default is square layout.", default=None)
    parser.add_argument('--pixel_size', type=int, help="Size of each pixel in the image. Default is 10.", default=10)
    parser.add_argument('--output_file', help="Name of the output image file. Default is 'binary_image.png'.", default='binary_image.png')
    
    args = parser.parse_args()

    create_binary_image_from_file(args.input_file, args.width, args.pixel_size, args.output_file)
