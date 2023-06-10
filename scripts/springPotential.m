function f = springPotential(h,Q,L,Lm)
f = h.*Q.*(1-L/vecnorm(Q))/(1-(vecnorm(Q)-L)/(Lm-L))^2 ;
end