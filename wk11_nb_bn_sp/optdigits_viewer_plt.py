########
# Viewing images from raw data
# http://ftp.ics.uci.edu/pub/machine-learning-databases/optdigits/
#
# Make sure you have a file named optdigits.tra.csv in the same directory
#  as this Python program
#
# Tested on Python 3.6

import matplotlib
matplotlib.use("TkAgg")

import matplotlib.pyplot as plt
import numpy as np


#training data
#fn = 'optdigits.tra.csv'

#testing data
fn = 'optdigits.tes.csv'

fh = open(fn,'r')
#first line in file is just header, not data
header = fh.readline()
print(header)


#read all data into array then close file
lines = fh.readlines()
fh.close()

#check out instance number 873
# it was predicted 3 but actually an 8 (based on IBk)
lines = lines[871:874]

#images are all 8 by 8
sz = 8

cnt = 0
#loop over each image (row in dataset)
for line in lines:
    line = line.replace('\n','')
    cnt += 1
    x = line.split(',')
    print(cnt,x)

    #create a blank image
    i = -1
    #create pixels and populate image
    px_list = []
    px_col = []
    for row in range(sz):
        px_col = []
        for col in range(sz):
            i += 1
            val = int(x[i])

            #change scale from 0-16 to 255-0
            intensity = int(((16-val)/16.0)*255)
            print(row,col,i,val,intensity)
            px = (intensity, intensity, intensity)
            px_col.append(tuple(px))

        px_list.append(px_col)
    px_list = np.array(px_list)
    digit = int(x[i+1])
    fig, ax = plt.subplots()
    im = ax.imshow(px_list)
    plt.savefig(str(cnt)+'.png')
    #plt.show()

