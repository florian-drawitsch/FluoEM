p = '/home/florian/Code/FluoEM'
p = 'C:\Users\drawitschf\Code\FluoEM'
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

skelReg = skelReg.skelRegister


figure
skelReg.skelPlot('include',{'fixed','moving_at'},'downsample',5,'labels', false)

figure
skelReg.skeletons.fixed.plot
hold on
skelReg.skeletons.moving_at.plot
view([0 90])


figure
skelReg.skelPlot('include',{'fixed','moving_at_ft'},'downsample',5,'labels', false)

figure
skelReg.skeletons.fixed.plot
hold on
skelReg.skeletons.moving_at_ft.plot
view([0 90])


skel_moving_at_ft_inv = skelReg.trafoFT.applyToSkel(skelReg.skeletons.moving_at_ft, 'inverse');

figure
skelReg.skeletons.fixed.plot
hold on
skel_moving_at_ft_inv.plot
view([0 90])
