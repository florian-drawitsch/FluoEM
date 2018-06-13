addpath(genpath('~/Code/FluoEM'))

fpath_em = '/home/florian/Code/florian-papers/longRangeConn/skeletons/axons/all_em.nml'
fpath_lm = '/home/florian/Code/florian-papers/longRangeConn/skeletons/axons/all_lm.nml'

fpath_em = '/home/florian/Code/florian-papers/longRangeConn/skeletons/axons/discovery/016_molly/molly_em.nml'
fpath_lm = '/home/florian/Code/florian-papers/longRangeConn/skeletons/axons/discovery/016_molly/molly_lm.nml'

fpath_em = 'C:\Users\drawitschf\Downloads\angelo_em.nml'
fpath_lm = 'C:\Users\drawitschf\Downloads\angelo_lm.nml'

skelReg = SkelReg(fpath_em,fpath_lm)
skelReg = skelReg.registerFreeForm
skelReg.plot('include',{'em','lm_at_ft'})
skelReg.findControlPointOutliers