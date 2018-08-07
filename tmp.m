p = '/home/florian/Code/FluoEM'
cd(p)
addpath(genpath(p))

fname_lm = fullfile(p,'data','axons_all_lm.nml')
fname_em = fullfile(p,'data','axons_all_em.nml')

cp = trafo.Cp()
cp = cp.readFromSkel(Skeleton(fullfile(p,'data','axons_all_lm.nml')), 'moving');
cp = cp.readFromSkel(Skeleton(fullfile(p,'data','axons_all_em.nml')), 'fixed');
cp = cp.match;

affine = trafo.Affine;
affine = affine.compute(cp.points.matched.xyz_moving, cp.points.matched.xyz_fixed, cp.points.moving.Properties.UserData.scale, cp.points.fixed.Properties.UserData.scale)


freeform = trafo.Freeform(cp.points.matched.xyz_moving, cp.points.matched.xyz_fixed, cp.points.moving.Properties.UserData.scale, cp.points.fixed.Properties.UserData.scale)



skelReg = SkelReg(fname_lm, fname_em)

skelReg = skelReg.trafoCompute('at')
skelReg = skelReg.trafoApply('at')

skelReg = skelReg.trafoCompute('ft')
skelReg = skelReg.trafoApply('ft')



skelReg.skelPlot('labels', false)