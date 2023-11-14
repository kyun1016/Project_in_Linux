import numpy as np
import lib.fixed_point_lib as fp

def mat_mul(input_data, filter, rl, cl):
    odata = input_data.copy()
    mat00 = input_data[:,:,0] * filter[0,0]
    mat01 = input_data[:,:,1] * filter[0,1]
    mat02 = input_data[:,:,2] * filter[0,2]
    mat00 = fp.round_array(mat00, rl)
    mat01 = fp.round_array(mat01, rl)
    mat02 = fp.round_array(mat02, rl)
    mat0 = mat00 + mat01 + mat02
    mat0 = fp.clip_array(mat0, cl)
    
    

    mat10 = input_data[:,:,0] * filter[1,0]
    mat11 = input_data[:,:,1] * filter[1,1]
    mat12 = input_data[:,:,2] * filter[1,2]
    mat10 = fp.round_array(mat10, rl)
    mat11 = fp.round_array(mat11, rl)
    mat12 = fp.round_array(mat12, rl)
    mat1 = mat10 + mat11 + mat12
    mat1 = fp.clip_array(mat1, cl)

    mat20 = input_data[:,:,0] * filter[2,0]
    mat21 = input_data[:,:,1] * filter[2,1]
    mat22 = input_data[:,:,2] * filter[2,2]
    mat20 = fp.round_array(mat20, rl)
    mat21 = fp.round_array(mat21, rl)
    mat22 = fp.round_array(mat22, rl)
    mat2 = mat20 + mat21 + mat22
    mat2 = fp.clip_array(mat2, cl)

    odata[:,:,0] = mat0
    odata[:,:,1] = mat1
    odata[:,:,2] = mat2
    return odata



def cov(input_data, filter, pad, rl, cl):
    H, W = input_data.shape
    f_H, f_W = filter.shape

    output_H = (H + 2 * pad - f_H) + 1
    output_W = (W + 2 * pad - f_W) + 1

    pad_data = np.pad(input_data, (int(pad), int(pad)), 'edge')
    output = np.zeros((output_H, output_W))

    for h in range(H):
        for w in range(W):
            conv = pad_data[h:h+f_H, w:w+f_W] * filter
            output[h, w] = np.sum(conv)

    output = fp.round_array(output, rl)
    output = fp.clip_array(output, cl)

    return output