import numpy as np
import lib.math as mt
import lib.fixed_point_lib as fp
import lib.read_write_lib as rw

if __name__ == "__main__":
    #############################
    # 1. Parameter setting
    #############################
    PPM_NAME = "sample3"
    INPUT_IMAGE_DIR = "./image/input/"
    OUTPUT_IMAGE_DIR = "./image/output/"

    INPUT_IMAGE_FILE_PATH = INPUT_IMAGE_DIR + PPM_NAME + ".ppm"
    OUTPUT_IMAGE_FILE1_PAHT = OUTPUT_IMAGE_DIR + PPM_NAME + "_1.ppm"
    OUTPUT_IMAGE_FILE2_PAHT = OUTPUT_IMAGE_DIR + PPM_NAME + "_2.ppm"
    OUTPUT_IMAGE_FILE3_PAHT = OUTPUT_IMAGE_DIR + PPM_NAME + "_3.ppm"
    OUTPUT_IMAGE_FILE4_PAHT = OUTPUT_IMAGE_DIR + PPM_NAME + "_4.ppm"

    rgb, IMG_WIDTH, IMG_HEIGHT, header = rw.image_read_ppm(INPUT_IMAGE_FILE_PATH)

    FILTER_SIZE = 5
    PADDING_SIZE = int(FILTER_SIZE/2)

    csc_coef = [[0.2126 , 0.7152  , 0.0722  ],
                [-0.09991, -0.33609, 0.436   ],
                [0.615  , -0.55861, -0.05639]]
    csc_coef = np.array(csc_coef)
    
    icsc_coef = [[1, 0       , 1.28033 ],
                 [1, -0.21482, -0.38059],
                 [1, 2.12798 , 0       ]]
    icsc_coef = np.array(icsc_coef)


    den_coef = np.ones((5,5)) / (FILTER_SIZE*FILTER_SIZE)
    shr_coef = -np.ones((5,5)) / (FILTER_SIZE*FILTER_SIZE - 1)
    shr_coef[2,2] = 1

    gaussian_smooting = [[1,  4,  7,  4, 1],
                         [4, 16, 26, 16, 4],
                         [7, 26, 41, 26, 7],
                         [4, 16, 26, 16, 4],
                         [1,  4,  7,  4, 1]]
    gaussian_smooting = np.array(gaussian_smooting, dtype=float)
    gaussian_smooting = gaussian_smooting/np.sum(gaussian_smooting)
    laplacian_of_gaussian = [[ 0,  0, -1,  0,  0],
                             [ 0, -1, -2, -1,  0],
                             [-1, -2, 16, -2, -1],
                             [ 0, -1, -2, -1,  0],
                             [ 0,  0, -1,  0,  0]]
    laplacian_of_gaussian = np.array(laplacian_of_gaussian, dtype=float)

    csc_rl = 8
    icsc_rl = 8
    shr_rl = 8
    den_rl = 8
    gau_rl = 8
    lap_rl = 8
    all_cl = 8
    
    csc_coef_fixed = fp.fixed_pts_array(csc_coef, csc_rl)
    den_coef_fixed = fp.fixed_pts_array(den_coef, den_rl)
    shr_coef_fixed = fp.fixed_pts_array(shr_coef, shr_rl)
    icsc_coef_fixed = fp.fixed_pts_array(icsc_coef, icsc_rl)
    gau_coef_fixed = fp.fixed_pts_array(gaussian_smooting, gau_rl)
    lap_coef_fixed = fp.fixed_pts_array(laplacian_of_gaussian, lap_rl)

    #############################
    # 2. Setting Parameter
    #############################
    mat1_coef = csc_coef_fixed
    mat2_coef = icsc_coef_fixed
    filter1_coef = den_coef_fixed
    filter2_coef = shr_coef_fixed

    mat1_rl = csc_rl
    mat2_rl = icsc_rl
    filter1_rl = den_rl
    filter2_rl = shr_rl
    #############################
    # 3. Main Operation
    #############################
    # Step 1. RGB to YUV
    csc_yuv = mt.mat_mul(rgb, mat1_coef, mat1_rl, all_cl)
    filter1_y = mt.cov(csc_yuv[:,:,0], filter1_coef, PADDING_SIZE, filter1_rl, all_cl)
    filter2_y = mt.cov(filter1_y     , filter2_coef, PADDING_SIZE, filter2_rl, all_cl)
    result_y = filter1_y + filter2_y
    result_y = np.where(result_y>= 255, 255, result_y)
    result_y = np.where(result_y<=   0,   0, result_y)

    #############################
    # 4. Print Result
    #############################
    # Step 4. YUV to RGB
    yuv = csc_yuv.copy()
    rgb1 = mt.mat_mul(yuv, mat2_coef, mat2_rl, all_cl)
    yuv[:,:,0] = filter1_y
    rgb2 = mt.mat_mul(yuv, mat2_coef, mat2_rl, all_cl)
    yuv[:,:,0] = filter2_y
    rgb3 = mt.mat_mul(yuv, mat2_coef, mat2_rl, all_cl)
    yuv[:,:,0] = result_y
    rgb4 = mt.mat_mul(yuv, mat2_coef, mat2_rl, all_cl)
    
    rw.image_write_ppm(OUTPUT_IMAGE_FILE1_PAHT, rgb1, header)
    rw.image_write_ppm(OUTPUT_IMAGE_FILE2_PAHT, rgb2, header)
    rw.image_write_ppm(OUTPUT_IMAGE_FILE3_PAHT, rgb3, header)
    rw.image_write_ppm(OUTPUT_IMAGE_FILE4_PAHT, rgb4, header)

    ###########################################################
    # a. verilog verification file dump
    ###########################################################
    np.savetxt('./verilog/csc_coef.txt', mat1_coef, fmt='%d')
    np.savetxt('./verilog/filter1_coef.txt', filter1_coef, fmt='%d')
    np.savetxt('./verilog/filter2_coef.txt', filter2_coef, fmt='%d')
    np.savetxt('./verilog/icsc_coef.txt', mat2_coef, fmt='%d')