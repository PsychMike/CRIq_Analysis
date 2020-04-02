function y = betainc(x,a,b,tail)
%BETAINC Incomplete beta function.
%   Y = BETAINC(X,Z,W) computes the incomplete beta function for
%   corresponding elements of X, Z, and W.  The elements of X must be in
%   the closed interval [0,1], and those of Z and W must be nonnegative.
%   X, Z, and W must all be real and the same size (or any of them can be
%   scalar).
%
%   The incomplete beta function is defined as
%
%     I_x(z,b) = 1./BETA(z,w) .*
%                 integral from 0 to x of t.^(z-1) .* (1-t).^(w-1) dt
%
%   Y = BETAINC(X,A,TAIL) specifies the tail of the incomplete beta
%   function.  Choices are 'lower' (the default) to compute the integral
%   from 0 to x, or 'upper' to compute the integral from x to 1.  These
%   functions are related as follows:
%
%        1-BETAINC(X,Z,W) = BETAINC(X,Z,W,'upper')
%
%   However, especially when the upper tail value is close to 0, it is more
%   accurate to use the 'upper' option than to subtract the 'lower' value
%   from 1.
%
%   If either Z or W is very large, BETAINC uses an approximation whose
%   absolute accuracy is at least 5e-3 if Z+W > 6.
%
%   Class support for inputs X,Z,W:
%      float: double, single
%
%   See also BETA, BETALN.

%   Ref: Abramowitz & Stegun, Handbook of Mathematical Functions, sec. 26.5,
%   especially 26.5.8, 26.5.20 and 26.5.21.

%   Copyright 1984-2007 The MathWorks, Inc.
%   $Revision: 5.16.4.10 $  $Date: 2007/05/23 18:54:59 $

if nargin < 3
    error('MATLAB:betainc:NotEnoughInputs','Requires three input arguments.')
elseif any(x(:) < 0 | x(:) > 1 | isnan(x(:))) || ~isreal(x)
    error('MATLAB:betainc:XoutOfRange','X must be in the interval [0,1].')
elseif any(a(:) < 0 | isnan(a(:))) || ~isreal(a)
    error('MATLAB:betainc:PositiveZ','Z must be real and nonnegative.')
elseif any(b(:) < 0 | isnan(b(:))) || ~isreal(b)
    error('MATLAB:betainc:PositiveW','W must be real and nonnegative.')
end

if nargin < 4
    lower = true;
else
    switch tail
      case 'lower'
        lower = true;
      case 'upper'
        lower = false;
      otherwise
        error('MATLAB:betainc:BadTail',...
              'TAIL must be ''lower'' or ''upper''.');
    end
end

try
    % Preallocate y (using the size rules for plus)
    y = x + a + b;    
catch
    error('MATLAB:betainc:XZWsizeMismatch', ...
          'X, Z and W must all the same size (or any of them can be scalar).')
end
% Initialize y(x==0) and y(x==1). Everything else will be filled in.
if lower
    y(:) = (x==1);
else
    y(:) = (x==0);
end

if ~isempty(y)
    % Use the continued fraction unless either parameter is very large.
    approx = (a+b) > 1e7;
    if isscalar(approx) && ~isscalar(y)
        k = repmat(~approx,size(y));
    else
        k = ~approx;
    end
    
    omx=1-x;  % one minus x
    if any(k(:)) && ~lower
        % in the rows indexed by k, swap a for b, x for 1-x
        if isscalar(a), a = repmat(a,size(y)); end
        if isscalar(b), b = repmat(b,size(y)); end
        if isscalar(x)
            omx = x;
            x = 1-x;
        else
            omx(k) = x(k);
            x(k) = 1-x(k);
        end
        temp = a(k);
        a(k) = b(k);
        b(k) = temp;
        temp = []; %save space, no longer used
    end
    
    k = (0 < x & x < (a+1) ./ (a+b+2) & ~approx);
    if any(k(:))
        if isscalar(x), xk = x; else xk = x(k); end
        if isscalar(a), ak = a; else ak = a(k); end
        if isscalar(b), bk = b; else bk = b(k); end
        % This is x^a * (1-x)^b / (a*beta(a,b)), computed so that a==0 works.
        btk = exp(gammaln(ak+bk) - gammaln(ak+1) - gammaln(bk) + ...
                                     ak.*log(xk) + bk.*log1p(-xk));
        y(k) = btk .* old_betacore(xk,ak,bk);
    end

    k = ((a+1) ./ (a+b+2) <= x & omx>0 & ~approx);
    if any(k(:))
        if isscalar(x), xk = x; omxk=omx; else xk = x(k);omxk=omx(k); end
        if isscalar(a), ak = a; else ak = a(k); end
        if isscalar(b), bk = b; else bk = b(k); end
        % This is x^a * (1-x)^b / (b*beta(a,b)), computed so that b==0 works.
        btk = exp(gammaln(ak+bk) - gammaln(ak) - gammaln(bk+1) + ...
                                     ak.*log(xk) + bk.*log1p(-xk));
        y(k) = 1 - btk .* old_betacore(omxk,bk,ak);
        
    end
  
    % NaNs may have come from a=b=0, leave those alone.  Otherwise if the
    % continued fraction in betacore failed to converge, or if we didn't use
    % it, use approximations.
    k = find((isnan(y) & (a+b>0)) | approx);
    if ~isempty(k)
        if isscalar(x), xk = x; else xk = x(k); end
        if isscalar(a), ak = a; else ak = a(k); end
        if isscalar(b), bk = b; else bk = b(k); end
        w1 = (bk.*xk).^(1/3);
        w2 = (ak.*(1-xk)).^(1/3);
        
        if lower
            sgn=+1;
        else
            sgn=-1;
        end
        y(k) = 0.5*erfc(-sgn*3/sqrt(2)*((1-1./(9*bk)).*w1-(1-1./(9*ak)).*w2)./ ...
               sqrt(w1.^2./bk+w2.^2./ak));
        
        k1 = find((ak+bk-1).*(1-xk) <= 0.8);
        if ~isempty(k1)
            if isscalar(x), xk = x; else xk = xk(k1); end
            if isscalar(a), ak = a; else ak = ak(k1); end
            if isscalar(b), bk = b; else bk = bk(k1); end
            s = 0.5*((ak+bk-1).*(3-xk)-(bk-1)).*(1-xk);
            if lower
                y(k(k1)) = gammainc(s,bk,'upper');
            else
                y(k(k1)) = gammainc(s,bk,'lower');
            end
        end
    end
end

function y = old_betacore(x, a, b)
%BETACORE Core algorithm for the incomplete beta function.
%   Y = BETACORE(X,A,B) computes a continued fraction expansion used by
%   BETAINC.  Specifically,
%
%      BETAINC(X,A,B) = BETACORE(X,A,B) * (X^A * (1-X)^B) / (A*BETA(A,B)).
%
%   X must be strictly between 0 and 1.  Returns NaN if continued fraction
%   does not converge.
%

%   Ref: Press, W.H., S.A. Teukolsky, W.T. Vetterling, and B.P. Flannery,
%   (1992) Numerical Recipes in C, 2nd Edition, Cambridge University Press.

aplusb = a + b;
aplus1 = a + 1;
aminus1 = a - 1;
C = 1;
% When called from BETAINC, Dinv can never be zero unless (a+b) or (a+1)
% round to a.
Dinv = 1 - aplusb .* x ./ aplus1;
y = C ./ Dinv;
maxiter = 1000;
for m = 1:maxiter
    yold = y;
    twom = 2 * m;
    d = m * (b - m) .* x ./ ((aminus1 + twom) .* (a + twom));
    C = 1 + d ./ C;
    % Using Dinv, not D, ensures that C = 1/D will be a stable fixed point
    Dinv = 1 + d ./ Dinv;
    y = y .* (C./Dinv);
    d = -(a + m) .* (aplusb + m) .* x ./ ((a + twom) .* (aplus1 + twom));
    C = 1 + d ./ C;
    Dinv = 1 + d ./ Dinv;
    y = y .* (C./Dinv);
    k = (abs(y(:)-yold(:)) > 1000*eps(y(:)));
    if ~any(k), break; end
end
if m > maxiter
    y(k) = NaN;
end
