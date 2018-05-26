from PIL import Image
from struct import *
import io

with open('rgb.dat', 'rb') as fp:
    img = Image.frombytes("RGBA", (128, 128), fp.read());
    img.save("out.png", "PNG")
