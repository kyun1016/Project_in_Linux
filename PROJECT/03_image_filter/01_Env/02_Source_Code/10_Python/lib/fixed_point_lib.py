import numpy as np

def func_round_diff(idata):
    odata = np.where(np.absolute(idata - idata.astype(np.int32)) >= 0.5, np.sign(idata) * (abs(idata).astype(np.int32)+1), idata.astype(np.int32))
    return odata

def round_array(idata, rl):
    odata = func_round_diff(idata/(2**rl))
    return odata

def clip_array(idata, cl):
    odata = np.where(idata > (2**cl - 1), 2**cl - 1, idata)
    return odata

def fixed_pts_array(idata, fl):
    odata = func_round_diff(idata*(2**fl))
    return odata