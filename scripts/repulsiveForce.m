function f = repulsiveForce(origin,X,Y,Z,D,epsilon)

if epsilon == 0
    f = zeros(3,size(X,2)) ;
else


A = X - origin(1) ;
B = Y - origin(2) ;
C = Z - origin(3) ;
direction_vectors = [A ; B ; C] ;
unitVec = direction_vectors ./ vecnorm(direction_vectors);
r = sqrt(A.^2 + B.^2 +C.^2) ;
f =   48 .* epsilon .* ((2.*D.^(12))./(r.^13)) .* unitVec; %- (D^(6))./(r.^7)) ;
for i = 1:size(A,2)
    if r(i) > 1.12*2*D
        f(:,i) = [0 ; 0 ; 0] ;
    end
end
f(isinf(f)) = 0 ;
f(isnan(f)) = 0 ;

end
end