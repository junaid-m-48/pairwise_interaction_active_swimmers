function Tdata = restructurePositionData(t,Position,swimmerType)

switch swimmerType
    case 'Two-Bead'
        IdxBody =  1:6:size(Position,2) ;
        IdxBead =  4:6:size(Position,2) ;
        Tdata = [] ;
        for b = 1:size(IdxBody,2)
            bodyPosition = [t' ; b*ones(1,size(Position,1)) ;  1*ones(1,size(Position,1)) ...
              ;  Position(:,IdxBody(b):IdxBody(b)+2)' ] ;
          
            beadPosition = [t' ; b*ones(1,size(Position,1)) ;  2*ones(1,size(Position,1)) ...
              ;  Position(:,IdxBead(b):IdxBead(b)+2)' ] ;
          Tdata = cat(2,Tdata,[bodyPosition beadPosition]) ;
        end
       
        
    case 'Three-Bead'
         IdxBody =  1:9:size(Position,2) ;
         IdxBeadLeft =  4:9:size(Position,2) ;
         IdxBeadRight =  7:9:size(Position,2) ;
         
         Tdata = [] ;
        for b = 1:size(IdxBody,2)
           bodyPosition = [t' ; b.*ones(1,size(Position,1)) ;  1.*ones(1,size(Position,1)) ...
              ;  Position(:,IdxBody(b):IdxBody(b)+2)' ] ;
           leftBeadPosition = [t' ; b.*ones(1,size(Position,1)) ;  2.*ones(1,size(Position,1)) ...
              ;  Position(:,IdxBeadLeft(b):IdxBeadLeft(b)+2)' ] ;
           rightBeadPosition = [t' ; b.*ones(1,size(Position,1)) ;  3.*ones(1,size(Position,1)) ...
              ;  Position(:,IdxBeadRight(b):IdxBeadRight(b)+2)' ] ;
          Tdata = cat(2,Tdata,[bodyPosition leftBeadPosition rightBeadPosition]) ;
        end
       

end  


end