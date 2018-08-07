p = '/home/florian/Code/FluoEM'
cd(p)
addpath(genpath(p))

skelReg = SkelReg(fullfile(pwd,'data','axons_all_lm.nml'), fullfile(pwd,'data','axons_all_em.nml'))

skel = Skeleton(fullfile(p,'data','axons_all_lm.nml'))
skel = Skeleton(fullfile(p,'data','axons_all_em.nml'))

cp = trafo.Cp()
cp = cp.readFromSkel(Skeleton(fullfile(p,'data','axons_all_lm.nml')), 'moving');
cp = cp.readFromSkel(Skeleton(fullfile(p,'data','axons_all_em.nml')), 'fixed');
cp = cp.match;

affine = trafo.Affine;
affine = affine.compute(cp.points.matched.xyz_moving, cp.points.matched.xyz_fixed, cp.points.moving.Properties.UserData.scale, cp.points.fixed.Properties.UserData.scale)

freeform = trafo.Freeform(cp.points.matched.xyz_moving, cp.points.matched.xyz_fixed, cp.points.moving.Properties.UserData.scale, cp.points.fixed.Properties.UserData.scale)