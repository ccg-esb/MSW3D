function cm = bipolar_brazil(m, n, interp)
%bipolar: symmetric/diverging/bipolar colormap, with neutral central color.
%
% Usage: cm = bipolar(m, neutral, interp)
%  neutral is the gray value for the middle of the colormap, default 1/3.
%  m is the number of rows in the colormap, defaulting to copy the current
%    colormap, or the colormap that MATLAB defaults for new figures.
%  interp is the method used to interpolate the colors, see interp1.
%
% The colormap goes from cyan-blue-neutral-red-yellow if neutral is < 0.5
% (the default) and from blue-cyan-neutral-yellow-red if neutral > 0.5.
%
% If neutral is exactly 0.5, then a map which yields a linear increase in
% intensity when converted to grayscale is produced (as derived in
% colormap_investigation.m). This colormap should also be reasonably good
% for colorblind viewers, as it avoids green and is predominantly based on
% the purple-yellow pairing which is easily discriminated by the two common
% types of colorblindness. For more details on this, see Brewer (1996):
% http://www.ingentaconnect.com/content/maney/caj/1996/00000033/00000002/art00002
% 
% Examples:
%  surf(peaks)
%  cmx = max(abs(get(gca, 'CLim')));
%  set(gca, 'CLim', [-cmx cmx]);
%  colormap(bipolar)
%
%  imagesc(linspace(-1, 1,201)) % symmetric data, if not set symmetric CLim
%  colormap(bipolar(201, 0.1)) % dark gray as neutral
%  axis off; colorbar
%  pause(2)
%  colormap(bipolar(201, 0.9)) % light gray as neutral
%  pause(2)
%  colormap(bipolar(201, 0.5)) % grayscale-friendly colormap
%
% See also: colormap, jet, interp1, colormap_investigation, dusk
% dusk is a colormap like bipolar(m, 0.5), in Oliver Woodford's real2rgb:
%  http://www.mathworks.com/matlabcentral/fileexchange/23342
%
% Copyright 2009 Ged Ridgway at gmail com
% Based on Manja Lehmann's hand-crafted colormap for cortical visualisation

if ~exist('interp', 'var')
    interp = [];
end

if ~exist('n', 'var') || isempty(n)
    n = 1/3;
end

    if isempty(interp)
        interp = 'linear';
    end
   
    cm = [
        0         1         1  %Susceptible
        1 1 1
        1         1        0  %Resistant
        ];

if m ~= size(cm, 1)
    xi = linspace(1, size(cm, 1), m);
    cm = interp1(cm, xi, interp);
end
