function [Ux,Uy,Uz] = regularizedStokesletVectorized(origin,X,Y,Z,s,f)
% origin and force should be column vectors

A = X - origin(1) ;
B = Y - origin(2) ;
C = Z - origin(3) ;

r = sqrt(A.^2 + B.^2 +C.^2) ;
a = r.^2+2*s^2 ;
b = r.^2+s^2; 

Ux = ((a./(b.^(3/2)) + ((A.*A)./(b.^(3/2)))).*f(1) + ...
    (A.*B.*f(2) + A.*C.*f(3))./(b.^(3/2)))./(8*1e-6*pi) ;

Uy = ((a./(b.^(3/2)) + ((B.*B)./(b.^(3/2)))).*f(2) + ...
    (A.*B.*f(1) + B.*C*f(3))./(b.^(3/2)))./(8*1e-6*pi) ;

Uz = ((a./(b.^(3/2)) + ((C.*C)./(b.^(3/2)))).*f(3) + ...
    (C.*B.*f(2) + C.*A.*(f(1)))./(b.^(3/2)))./(8*1e-6*pi) ;


end



