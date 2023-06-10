function dxdt = motionDeffTwobead(t,x,F,E,A,L,Lm,H,t_active)


       dxdt = zeros(size(x,1),1)  ;
        x = x(:);
       p = reshape(x,3,size(x,1)/3) ; % reshaping to get each row as x,y and z component
       X = p(1,:) ;
       Y = p(2,:) ;
       Z = p(3,:) ;
       % reshaping to acquire P cell arayy simialr to Position array from
       % create swimmer function
       if size(p,2)/2 ==1
                P =  reshape(num2cell(p,1),size(p,2)/2,2);
       else
                P =  reshape(num2cell(p,1),size(p,2)/2,2)';
       end
       
       % Calculation of repulsive force
       
      fc_R = cell(size(P)) ;
      for i = 1:size(P,1)
           for j = 1:2
               fc_R{i,j} = repulsiveForce(P{i,j},X,Y,Z,A(j),E) ;
           end
      end
       fr = cell2mat(reshape(fc_R',1,1,[])) ;
       fR = sum(fr,3) ;
       FR =  reshape(num2cell(fR,1),2,size(p,2)/2)' ;
       
       Velocity = cell(size(P)) ;
       Velocity_R = cell(size(P)) ;
       fc_T = cell(size(P)) ;
       fc = zeros(3,2) ;
       N = zeros(3,size(P,1));
     
       for i = 1:size(P,1)
          Q1 = P{i,2} - P{i,1} ;
          Q2 = P{i,1} - P{i,2} ;
          n =  P{i,2} - P{i,1} ;
          N(:,i) = n./vecnorm(n) ;
          
          fc(:,1) = springPotential(H,Q1,L,Lm) ;
          fc(:,2) = springPotential(H,Q2,L,Lm) ;
          fc_T{i,1} =  fc(:,1) ;
          fc_T{i,2} =  fc(:,2) ;
      
           for j = 1:2
               [Ux,Uy,Uz] = regularizedStokesletVectorized(P{i,j},X,Y,Z,A(j),fc_T{i,j});
               Velocity{i,j} = [Ux;Uy;Uz];
               [UxR,UyR,UzR] = regularizedStokesletVectorized(P{i,j},X,Y,Z,A(j),FR{i,j});
               Velocity_R{i,j} = [UxR;UyR;UzR];
           end
     
       end
       
        
       
       % sum of velocity at each location
        
       U = cell2mat(reshape(Velocity',1,1,[])) ;
       
       UR = cell2mat(reshape(Velocity_R',1,1,[])) ;
       for u = 1:size(p,2)
           U(:,u,u) = [0 0 0]' ;
       end
       
       
       U = sum(U,3) + sum(UR,3) ;
       V =  reshape(num2cell(U,1),2,size(p,2)/2)' ;
     
       
    
       
       
       eta = 6*pi*A*1e-6 ;
       position = cell(size(P)) ;
       kd = [0 1] ;
       forces = F.*N ;
       st = 1 ;
       en = st+2 ;
       for i = 1:size(P,1)
           for j = 1:2
               if t>t_active
                   position{i,j} = (1/eta(j))*(kd(j)*forces(:,i) + fc_T{i,j} + FR{i,j}) +  V{i,j} ;
               else
                   position{i,j} = (1/eta(j))*(kd(j)*forces(:,i) + fc_T{i,j} + FR{i,j}) ;
                   
               end
               dxdt(st:en) =   position{i,j};
               st = st+3;
               en = st+2;
           end
       end

end