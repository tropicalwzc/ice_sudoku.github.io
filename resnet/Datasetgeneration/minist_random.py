import numpy as np
import struct
import cv2
import os
from random import randint
import matplotlib.pyplot as plt

# 训练集文件
train_images_idx3_ubyte_file = "C:/Users/wzc99/Downloads/train-images-idx3-ubyte/train-images.idx3-ubyte"
# 训练集标签文件
train_labels_idx1_ubyte_file = "C:/Users/wzc99/Downloads/train-labels-idx1-ubyte/train-labels.idx1-ubyte"

# 测试集文件
test_images_idx3_ubyte_file = "C:/Users/wzc99/Downloads/t10k-images-idx3-ubyte/t10k-images.idx3-ubyte"
# 测试集标签文件
test_labels_idx1_ubyte_file = "C:/Users/wzc99/Downloads/t10k-labels-idx1-ubyte/t10k-labels.idx1-ubyte"


def decode_idx3_ubyte(idx3_ubyte_file):
    """
    解析idx3文件的通用函数
    :param idx3_ubyte_file: idx3文件路径
    :return: 数据集
    """
    # 读取二进制数据
    bin_data = open(idx3_ubyte_file, 'rb').read()

    # 解析文件头信息，依次为魔数、图片数量、每张图片高、每张图片宽
    offset = 0
    fmt_header = '>iiii' #因为数据结构中前4行的数据类型都是32位整型，所以采用i格式，但我们需要读取前4行数据，所以需要4个i。我们后面会看到标签集中，只使用2个ii。
    magic_number, num_images, num_rows, num_cols = struct.unpack_from(fmt_header, bin_data, offset)
    print('魔数:%d, 图片数量: %d张, 图片大小: %d*%d' % (magic_number, num_images, num_rows, num_cols))

    # 解析数据集
    image_size = num_rows * num_cols
    offset += struct.calcsize(fmt_header)  #获得数据在缓存中的指针位置，从前面介绍的数据结构可以看出，读取了前4行之后，指针位置（即偏移位置offset）指向0016。
    print("offset:",offset)
    fmt_image = '>' + str(image_size) + 'B'  #图像数据像素值的类型为unsigned char型，对应的format格式为B。这里还有加上图像大小784，是为了读取784个B格式数据，如果没有则只会读取一个值（即一副图像中的一个像素值）
    print(fmt_image,offset,struct.calcsize(fmt_image))
    images = np.empty((num_images, num_rows, num_cols))
    #plt.figure()
    for i in range(num_images):
        if (i + 1) % 10000 == 0:
            print('已解析 %d' % (i + 1) + '张')
            print(offset)
        images[i] = np.array(struct.unpack_from(fmt_image, bin_data, offset)).reshape((num_rows, num_cols))####
        #print(images[i])
        offset += struct.calcsize(fmt_image)
#        plt.imshow(images[i],'gray')
#        plt.pause(0.00001)
#        plt.show()
    #plt.show()

    return images


def decode_idx1_ubyte(idx1_ubyte_file):
    """
    解析idx1文件的通用函数
    :param idx1_ubyte_file: idx1文件路径
    :return: 数据集
    """
    # 读取二进制数据
    bin_data = open(idx1_ubyte_file, 'rb').read()

    # 解析文件头信息，依次为魔数和标签数
    offset = 0
    fmt_header = '>ii'
    magic_number, num_images = struct.unpack_from(fmt_header, bin_data, offset)###
    print('魔数:%d, 图片数量: %d张' % (magic_number, num_images))

    # 解析数据集
    offset += struct.calcsize(fmt_header)
    fmt_image = '>B'
    labels = np.empty(num_images)
    for i in range(num_images):
        if (i + 1) % 10000 == 0:
            print ('已解析 %d' % (i + 1) + '张')
        ##labels[i] = np.array(struct.unpack_from(fmt_image, bin_data, offset)).reshape((1, 1))####等价于下面那一行
        labels[i] = struct.unpack_from(fmt_image, bin_data, offset)[0]
        offset += struct.calcsize(fmt_image)
    return labels


def load_train_images(idx_ubyte_file = train_images_idx3_ubyte_file):
    """
    TRAINING SET IMAGE FILE (train-images-idx3-ubyte):
    [offset] [type]          [value]          [description]
    0000     32 bit integer  0x00000803(2051) magic number
    0004     32 bit integer  60000            number of images
    0008     32 bit integer  28               number of rows
    0012     32 bit integer  28               number of columns
    0016     unsigned byte   ??               pixel
    0017     unsigned byte   ??               pixel
    ........
    xxxx     unsigned byte   ??               pixel
    Pixels are organized row-wise. Pixel values are 0 to 255. 0 means background (white), 255 means foreground (black).

    :param idx_ubyte_file: idx文件路径
    :return: n*row*col维np.array对象，n为图片数量
    """
    return decode_idx3_ubyte(idx_ubyte_file)


def load_train_labels(idx_ubyte_file = train_labels_idx1_ubyte_file):
    """
    TRAINING SET LABEL FILE (train-labels-idx1-ubyte):
    [offset] [type]          [value]          [description]
    0000     32 bit integer  0x00000801(2049) magic number (MSB first)
    0004     32 bit integer  60000            number of items
    0008     unsigned byte   ??               label
    0009     unsigned byte   ??               label
    ........
    xxxx     unsigned byte   ??               label
    The labels values are 0 to 9.

    :param idx_ubyte_file: idx文件路径
    :return: n*1维np.array对象，n为图片数量
    """
    return decode_idx1_ubyte(idx_ubyte_file)


def load_test_images(idx_ubyte_file=test_images_idx3_ubyte_file):
    """
    TEST SET IMAGE FILE (t10k-images-idx3-ubyte):
    [offset] [type]          [value]          [description]
    0000     32 bit integer  0x00000803(2051) magic number
    0004     32 bit integer  10000            number of images
    0008     32 bit integer  28               number of rows
    0012     32 bit integer  28               number of columns
    0016     unsigned byte   ??               pixel
    0017     unsigned byte   ??               pixel
    ........
    xxxx     unsigned byte   ??               pixel
    Pixels are organized row-wise. Pixel values are 0 to 255. 0 means background (white), 255 means foreground (black).

    :param idx_ubyte_file: idx文件路径
    :return: n*row*col维np.array对象，n为图片数量
    """
    return decode_idx3_ubyte(idx_ubyte_file)


def load_test_labels(idx_ubyte_file=test_labels_idx1_ubyte_file):
    """
    TEST SET LABEL FILE (t10k-labels-idx1-ubyte):
    [offset] [type]          [value]          [description]
    0000     32 bit integer  0x00000801(2049) magic number (MSB first)
    0004     32 bit integer  10000            number of items
    0008     unsigned byte   ??               label
    0009     unsigned byte   ??               label
    ........
    xxxx     unsigned byte   ??               label
    The labels values are 0 to 9.

    :param idx_ubyte_file: idx文件路径
    :return: n*1维np.array对象，n为图片数量
    """
    return decode_idx1_ubyte(idx_ubyte_file)


TRAIN_IMAGES_DIR = "train_images/"
TEST_IMAGES_DIR = "test_images/"

TRAIN_IMAGE_DATASET_PATH = train_images_idx3_ubyte_file
TRAIN_LABEL_DATASET_PATH = train_labels_idx1_ubyte_file
TEST_IMAGE_DATASET_PATH = test_images_idx3_ubyte_file
TEST_LABEL_DATASET_PATH = test_labels_idx1_ubyte_file

MERGE_DIR = 'C:/Users/wzc99/anacondaWork/week7/Coloring'

def convert_to_image(dataset_type, use_merge_dir = False, export_num = 0):
    extra_end = 'white'
    is_test = True
    if dataset_type == "train":
        extra_end = 'black'
        is_test = False
        images_dir = TRAIN_IMAGES_DIR
        image_dataset = open(TRAIN_IMAGE_DATASET_PATH, "rb")
        label_dataset = open(TRAIN_LABEL_DATASET_PATH, "rb")
    elif dataset_type == "test":
        images_dir = TEST_IMAGES_DIR
        image_dataset = open(TEST_IMAGE_DATASET_PATH, "rb")
        label_dataset = open(TEST_LABEL_DATASET_PATH, "rb")
    else:
        print("Invalid type.")
        return

    counter = [0] * 10

    image_magic_number = int.from_bytes(image_dataset.read(4), byteorder='big', signed=False)
    image_num = int.from_bytes(image_dataset.read(4), byteorder='big', signed=False)
    image_row = int.from_bytes(image_dataset.read(4), byteorder='big', signed=False)
    image_col = int.from_bytes(image_dataset.read(4), byteorder='big', signed=False)

    label_magic_number = int.from_bytes(label_dataset.read(4), byteorder='big', signed=False)
    label_num = int.from_bytes(label_dataset.read(4), byteorder='big', signed=False)

    for i in range(10):
        if not os.path.exists(images_dir + str(i)):
            os.makedirs(images_dir + str(i))

    for i in range(image_num):


        if i > 10000:
            if i%2 == 0:
                is_test = True
            else:
                is_test = False

        image = []
        lighter = randint(0, 100)
        twisted_dark_s = [randint(0,100),randint(0,100),randint(0,100)]
        twisted_light_s = [155+randint(0,100),155+randint(0,100),155+randint(0,100)]
        for j in range(image_row * image_col):
            if is_test:
                lastint = 255 - int.from_bytes(image_dataset.read(1), byteorder='big', signed=False)
            else:
                lastint = int.from_bytes(image_dataset.read(1), byteorder='big', signed=False)



            for p in range(0,3):
                if(randint(0,15)!=0):
                    if lastint > 128:
                        image.append(twisted_light_s[p])
                    else:
                        image.append(twisted_dark_s[p])
                else:
                    randii = randint(0, 255)
                    image.append(randii)



        image = np.array(image, dtype=np.uint8).reshape((image_row, image_col, 3))

        label = int.from_bytes(label_dataset.read(1), byteorder='big', signed=False)



        counter[label] += 1

        if use_merge_dir:
            if label == 0:
               # print("no zero")
                continue

        if not use_merge_dir:
            image_path = images_dir + str(label) + "/" + str(label) + "." + str(counter[label]) + extra_end+ ".jpg"
        else:
            image_path = MERGE_DIR + "/" + str(label) + "/" + str(label) + "." + str(counter[label]) + extra_end + ".jpg"

        cv2.imwrite(image_path, image)

        if (i + 1) % 1000 == 0:
            print("Running, " + dataset_type + " images: " + str(i + 1) + "/" + str(image_num))

        if use_merge_dir:
            if i > export_num:
                break

        # cv2.imshow('image', image)
        # cv2.waitKey(0)
        # cv2.destroyAllWindows()
    image_dataset.close()
    label_dataset.close()

    print(dataset_type + " dataset finished.")


if __name__ == "__main__":
    # convert_to_image("train")
    convert_to_image("test", use_merge_dir=True, export_num=10000)
    convert_to_image("train", use_merge_dir=True, export_num=60000)
    print("All finished.")


# if __name__ == '__main__':                      ###
#     train_images = load_train_images()
#     train_labels = load_train_labels()
#     # test_images = load_test_images()
#     # test_labels = load_test_labels()
#
#     # 查看前十个数据及其标签以读取是否正确
#     for i in range(10):
#         print(train_labels[i])#train_labels   test_labels
#         plt.imshow(train_images[i], cmap='gray')#train_images  test_images
#         plt.pause(0.000001)
#         plt.show()
#     print('done')
