import numpy as np

def image_read_ppm(dirFile):
    f = open(dirFile, 'r')
    header_1 = f.readline()
    header_2 = f.readline()
    header_3 = f.readline()

    IMG_WIDTH  = int(header_2.split()[0])
    IMG_HEIGHT = int(header_2.split()[1])

    header = np.array([header_1, header_2, header_3])
    data = f.read().replace("\r", " ").replace("\n", " ")
    dataTmp = data.split()
    dataList = dataTmp[:IMG_HEIGHT*IMG_WIDTH*3]
    outData = np.array(dataList, dtype=int).reshape(IMG_HEIGHT, IMG_WIDTH, 3)

    return outData, IMG_WIDTH, IMG_HEIGHT, header

def image_write_ppm(dirFile, imgData, header):
    header_1 = header[0]
    header_2 = header[1]
    header_3 = header[2]

    IMG_WIDTH  = int(header_2.split()[0])
    IMG_HEIGHT = int(header_2.split()[1])
    
    rgb = imgData.copy()
    rgb = np.where(rgb >= 255, 255, rgb)
    rgb = np.where(rgb <= 0, 0, rgb)
    rgb = imgData.astype(np.int32)

    with open(dirFile, 'w') as f:
        f.write(header_1)
        f.write(header_2)
        f.write(header_3)
        for i in range(IMG_HEIGHT):
            for j in range(IMG_WIDTH):
                f.write(str(rgb[i,j,0]) + " " )
                f.write(str(rgb[i,j,1]) + " " )
                f.write(str(rgb[i,j,2]) + "\n")