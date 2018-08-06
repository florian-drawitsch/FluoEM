p = '/home/florian/Code/FluoEM'
cd(p)
addpath(genpath(p))

skelReg = SkelReg(fullfile(pwd,'data','axons_all_lm.nml'), fullfile(pwd,'data','axons_all_em.nml'))


cp = trafo.Cp(fullfile(pwd,'data','axons_all_lm.nml'), fullfile(pwd,'data','axons_all_em.nml'))


affine = trafo.Affine(cp.points.matched.xyz_moving, cp.points.matched.xyz_fixed, cp.points.moving.Properties.UserData.scale, cp.points.fixed.Properties.UserData.scale)