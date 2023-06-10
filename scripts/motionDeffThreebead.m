function dxdt  = motionDeffThreebead(t,x,F,E,A,L,Lm,H,t_active,couplingCriterion) 


       dxdt = zeros(size(x,1),1)  ;
       x = x(:) ;
       p = reshape(x,3,size(x,1)/3) ;  % reshaping to get each row as x,y and z component
       X = p(1,:) ;
       Y = p(2,:) ;
       Z = p(3,:) ;
       % reshaping to acquire P cell arayy simialr to Position array from
       % create swimmer function
     
       P =  reshape(num2cell(p,1),3,size(p,2)/3)';
       fc_R = cell(size(P)) ;
       for i = 1:size(P,1)
           for j = 1:3
               fc_R{i,j} = repulsiveForce(P{i,j},X,Y,Z,A(j),E) ;
           end
       end
       fr = cell2mat(reshape(fc_R',1,1,[])) ;
       fR = sum(fr,3) ;
%        
       FR =  reshape(num2cell(fR,1),3,size(p,2)/3)' ;
     
       Velocity = cell(size(P)) ;
       Velocity_R = cell(size(P)) ;
       fc_T = cell(size(P)) ;
       N = zeros(3,size(P,1)); 
       fc = zeros(3,3) ;
      
       for i = 1:size(P,1)
           
           n = (P{i,3} + P{i,2})/2 - P{i,1};
           N(:,i) = n./vecnorm(n);
           
           Q1 = P{i,3} - P{i,1} ; % connector vector are defined counterclockwise from bead B,R,L
           Q2 = P{i,2} - P{i,3} ;
           Q3 = P{i,1} - P{i,2} ;
           
           fc(:,1) = springPotential(H,Q1,L(1),Lm(1)) ; 
           fc(:,2) = springPotential(H,Q2,L(2),Lm(2)) ;
           fc(:,3) = springPotential(H,Q3,L(1),Lm(1)) ;
           
           fc_T{i,1} =  fc(:,1) - fc(:,3) ;
           fc_T{i,2} = - fc(:,2) + fc(:,3) ;
           fc_T{i,3} = + fc(:,2) - fc(:,1) ;
           fc_process = [fc_T{i,1},fc_T{i,2},fc_T{i,3}] ;
           for j = 1:3
               [Ux,Uy,Uz] = regularizedStokesletVectorized(P{i,j},X,Y,Z,A(j),(fc_process(:,j)));
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
       
      if size(P,1)==2 && strcmp(couplingCriterion,'one-way')
          U(:,:,4:end) = [] ;
      end
      
      
      U_noef = cell(1,size(p,2)/3) ;
      U_noef(:) = {U};
      c1  = 1 ;
      c2  = 3 ;
      total_index = 1:size(U,2);
      for i = 1:size(U_noef,2)
          U_noef{i} = U_noef{i}(:,:,c1:c2) ;
          remove_index = ismember(total_index,c1:c2);
          U_noef{i}(:,~remove_index,:) = 0.*U_noef{i}(:,~remove_index,:) ;
          c1 = c1+3;
          c2 = c2+3;
      end
      U_noef = cellfun(@(x) sum(x,3),U_noef,'UniformOutput',false) ;
      U_noef = reshape(cell2mat(U_noef),3,size(U,2),[]);
      U_noeffect = sum(U_noef,3);
      
     
       
  
  
      U = sum(U,3) + sum(UR,3) ;
      V =  reshape(num2cell(U,1),3,size(p,2)/3)' ;
      
      V_noeffect =  reshape(num2cell(U_noeffect,1),3,size(p,2)/3)' ;
   
      
       eta = 6*pi*A*1e-6 ;
       position = cell(size(P)) ;
       kd = [0 1/2 1/2] ;
       forces = F.*N ;
       st = 1 ;
       en = st+2 ;
       for i = 1:size(P,1)
           for j = 1:3
               if t>t_active
                   position{i,j} = (1/eta(j))*(kd(j)*forces(:,i)+fc_T{i,j} + FR{i,j}) + V{i,j} ;
               else
                   position{i,j} = (1/eta(j))*(kd(j)*forces(:,i)+fc_T{i,j}) + V_noeffect{i,j} ;
               end
               dxdt(st:en) =   position{i,j};
               st = st+3;
               en = st+2;
           end
       end

end