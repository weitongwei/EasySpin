% voigtian  Voigtian line shape function 
%
%   ya = voigtian(x,x0,fwhmGL)
%   ya = voigtian(x,x0,fwhmGL,diff)
%   ya = voigtian(x,x0,fwhmGL,diff,phase)
%   [ya,yd] = voigtian(...)
%
%    Computes an area-normalized Voigt line shape function, which is
%    the convolution of a Gaussian and a Lorentzian line shape function.
%
%   Input:
%   - x:     abscissa vector
%   - x0:    center of the lineshape function
%   - fwhmGL:  full widths at half height [fwhm_Gauss fwhm_Lorentz]
%   - diff:  derivative. 0 is no derivative, 1 first,
%            2 second and so on, -1 the integral with -infinity
%            as lower limit. 0 is the default.
%   - phase: phase rotation, mixes absorption and dispersion.
%            phase=pi/2 puts dispersion signal into ya
%
%   Output:
%   - ya:   absorption function values for abscissa x
%   - yd:   dispersion function values for abscissa x

function [y1,y2] = voigtian(x,x0,fwhmGL,diff,phase)

if nargin==0, help(mfilename); return; end

if (nargin<3), error('Not enough input arguments!'); end
if (nargin>5), error('Too many input arguments!'); end

if numel(fwhmGL)~=2
  error('fwhm must contain 2 values!');
end

if any(fwhmGL<0)
  error('fwhm must be all positive');
end

if all(fwhmGL==0)
  error('At least one value in fwhm must be nonzero.');
end

if (nargin<4), diff = 0; end
if (nargin<5), phase = 0; end

Quadrature = (nargout>1);

fwhmG = fwhmGL(1);
fwhmL = fwhmGL(2);
x0center = x(ceil(numel(x)/2));
if (fwhmG>fwhmL)
  diffG = diff;
  phaseG = phase;
  x0G = x0;
  diffL = 0;
  phaseL = 0;
  x0L = x0center;  
else
  diffG = 0;
  phaseG = 0;
  x0G = x0center;  
  diffL = diff;
  phaseL = phase;
  x0L = x0;
end

% Compute Gaussian and Lorentzian
% One of the two lineshapes must be centered in range to yield
% correct final lineshape position
if Quadrature
  if (fwhmG>0)
    [yG1,yG2] = gaussian(x,x0G,fwhmG,diffG,phaseG);
  end
  if (fwhmL>0)
    [yL1,yL2] = lorentzian(x,x0L,fwhmL,diffL,phaseL);
  end
else
  if (fwhmG>0)
    yG1 = gaussian(x,x0G,fwhmG,diffG,phaseG);
    yG2 = [];
  end
  if (fwhmL>0)
    yL1 = lorentzian(x,x0L,fwhmL,diffL,phaseL);
    yL2 = [];
  end
end

DoConvolution = (fwhmL>0) && (fwhmG>0);
if DoConvolution
  
  % Convolution
  y1 = conv(yG1,yL1);
  if Quadrature
    y2 = conv(yG2,yL2);
  end
  
  % Take central part
  n = length(yG1);
  m = ceil(n/2);
  y1 = y1(m:end-n+m);
  if Quadrature
    y2 = y2(m:end-n+m);
  end
  
  % Re-normalize
  dx = x(2)-x(1);
  y1 = y1*dx;
  if Quadrature
    y2 = y2*dx;
  end
  
else
  
  % Skip convolution in the case of a pure Gaussian or pure Lorentzian
  if (fwhmL>0)
    y1 = yL1;
    y2 = yL2;
  else
    y1 = yG1;
    y2 = yG2;
  end
  
end

return
