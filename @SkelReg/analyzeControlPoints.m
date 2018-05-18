function analyzeControlPoints( obj )
%ANALYSECONTROLPOINTS Summary of this function goes here
%   Detailed explanation goes here

pn_em = pnorm( obj.controlPoints.matched.xyz_em, obj.skeletons.em.scale );
pn_lm = pnorm( obj.controlPoints.matched.xyz_lm, obj.skeletons.lm.scale );

figure
imagesc(abs(pn_em-pn_lm))

end

