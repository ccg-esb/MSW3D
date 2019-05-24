function cm = bipolar(m, n, wmap)
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

if ~exist('wmap', 'var')
    wmap = [];
end

if ~exist('n', 'var') || isempty(n)
    n = 1/3;
end

if ~exist('m', 'var') || isempty(m)
    if isempty(get(0, 'CurrentFigure'))
        m = get(0, 'DefaultFigureColormap');
    else
        m = get(gcf, 'Colormap');
    end
    m = size(m, 1);
end

interp = 'linear'; 
%interp = 'cubic'; 
if strcmp(wmap,'astonvilla')
    cm = [
        0.50588    0.031373     0.13725
        0.7451     0.18824     0.21176
        n n n
        0.070588     0.28627     0.51765
        0.019608     0.15294     0.30588
        ];
    
    
elseif strcmp(wmap,'test')
    cm = [
        0   0   0
        .2 .2 .2
        .4 .4 .4
        .7 .7 .7
        .8 .8 .8
        .9 .9 .9
        1  1 1
        ];
        cm=flipud(cm);
        
elseif strcmp(wmap,'portvale')
    cm = [
        0   0   0
        .2 .2 .2
        .4 .4 .4
        .95 .95 .95
        1  1 1
        ];
        cm=flipud(cm);        
        
elseif strcmp(wmap,'torquay')
    cm = [
        1 1 0
        1         0.4           0
        0.1 0.1 0.1
        0  0  1
        1  1 1
        ];
        cm=flipud(cm);
       
else   %blue green
    cm = [
        [0.15294     0.22745     0.37255]
        [0.39216     0.47451     0.63529]
        n n n
        [0.23137     0.44314     0.33725]
        [0.070588     0.21176     0.14118]
        ];    
end

if m ~= size(cm, 1)
    xi = linspace(1, size(cm, 1), m);
    cm = interp1(cm, xi, interp);
end
