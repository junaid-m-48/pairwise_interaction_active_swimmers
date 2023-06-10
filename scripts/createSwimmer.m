function [position,n] = createSwimmer(b_location,s_direction,f_angle,L_f,whichSwimmer,A,plot_func)

if nargin < 7
    plot_func = 0 ;
end

s_direction = deg2rad(s_direction);
switch whichSwimmer
    case 'Three-Bead'
        position = cell(size(b_location,1),3); % first column body bead,second column left bead
        n = zeros(3,size(b_location,1)) ;
        for p = 1:size(b_location,1)
            d = eul2rotm(s_direction(p,:),'ZYX')*[1 0 0]' ;
            n(:,p) = d ;
            rotmat = rotmatA2B(d,[0 0 1]) ;
            
            
            
            f_1 = L_f*sin(f_angle(p,1)).*[1 0 0] + L_f*cos(f_angle(p,1)).*[0 0 1] ;
            f_2 = L_f*sin(-f_angle(p,1)).*[1 0 0] + L_f*cos(-f_angle(p,1)).*[0 0 1] ;
            
            rot2 =    eul2rotm([0 0 f_angle(p,2)],'XYZ') ;
            pos = rotmat\(rot2*[[0 0 0]' f_1' f_2']) ;
            
            
            p_L = pos(:,2) + b_location(p,:)'  ;
            p_R = pos(:,3) + b_location(p,:)' ;
            p_B = b_location(p,:)' ;
            
            position{p,1} = p_B ;
            position{p,2} = p_L ;
            position{p,3} = p_R ;
            if 0
                figure;
                plot3(p_B(1),p_B(2),p_B(3),'ow','MarkerSize',13,'Markerface','b');
                hold on
                plot3(p_L(1),p_L(2),p_L(3),'or','MarkerSize',7,'Markerface','r');
                plot3(p_R(1),p_R(2),p_R(3),'or','MarkerSize',7,'Markerface','r');
                quiver3(p_B(1),p_B(2),p_B(3),d(1),d(2),d(3))
                axis equal
            end
        end
    case 'Two-Bead'
        position = cell(size(b_location,1),2); % first column body bead,second column force_bead
        n = zeros(3,size(b_location,1)) ;
        for p = 1:size(b_location,1)
            d = eul2rotm(s_direction(p,:),'XYZ')*[1 0 0]' ;
            n(:,p) = d ;
            p_F = L_f.*d./vecnorm(d') + b_location(p,:)' ;
            
            p_B = b_location(p,:)' ;
            
            position{p,1} = p_B ;
            position{p,2} = p_F ;
        end
        
end

switch whichSwimmer
    case 'Two-Bead'
        A_mat = [A A].*1000;
    case 'Three-Bead'
        A_mat = [A A/2 A/2].*1000 ;
end

% Swimmwer plot
[sX,sY,sZ] = sphere(11) ;
sX2 = sX .* A_mat(1);
sY2 = sY .* A_mat(1);
sZ2 = sZ .* A_mat(1);
sX3 = sX .* A_mat(2);
sY3 = sY .* A_mat(2);
sZ3 = sZ .* A_mat(2);
P = position ;

if plot_func
    h1=figure;
    h1.Color=[1 1 1];
    h1.Units= 'normalized';
    h1.OuterPosition=[0.15 0.15 0.5 0.5];
    clf
    for i = 1:size(P,1)
        p = cell2mat(P(i,:)) ;
        p = [p p(:,1)].*1000 ;
       
        switch whichSwimmer
            case 'Two-Bead'
                
                plotPoints = p ;
            case 'Three-Bead'
                
                plotPoints = [p(:,2) p(:,1) p(:,3)] ;
                
        end
        plot3(plotPoints(1,:),plotPoints(2,:),plotPoints(3,:),'k-o','Linewidth',2)
        
        hold on
        surf(sX2+p(1,1),sY2+p(2,1),sZ2+p(3,1),'FaceColor',[0 0.6 0],'LineStyle','-','EdgeColor',[0 0.5 0])
        
        switch whichSwimmer
            case 'Two-Bead'
                surf(sX3+p(1,2),sY3+p(2,2),sZ3+p(3,2),'FaceColor',[0.5 0.5 0.5],'LineStyle','none')
            case 'Three-Bead'
                surf(sX3+p(1,2),sY3+p(2,2),sZ3+p(3,2),'FaceColor',[0.5 0.5 0.5],'LineStyle','none')
                surf(sX3+p(1,3),sY3+p(2,3),sZ3+p(3,3),'FaceColor',[0.5 0.5 0.5],'LineStyle','none')
        end
        
        camproj perspective
        set(gca, 'FontSize', 20, 'LineWidth', 0.5,'TickLabelInterpreter','latex');
        axis equal
        
        
    end
end