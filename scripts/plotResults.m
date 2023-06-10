function plotResults(Tdata, time, timeSteps, no_swimmer, swimmerType, A_mat ,video_make,plot_interaction)

%% Plotting

% Swimmwer plot
[sX,sY,sZ] = sphere(11) ;
sX2 = sX .* A_mat(1) .* 1000;
sY2 = sY .* A_mat(1) .* 1000;
sZ2 = sZ .* A_mat(1) .* 1000;
sX3 = sX .* A_mat(2) .* 1000;
sY3 = sY .* A_mat(2) .* 1000;
sZ3 = sZ .* A_mat(2) .* 1000;

t_start_interaction = find(time==0) ;
if strcmp(video_make,'on')
    v = VideoWriter([swimmerType,'.mp4'],'MPEG-4');
    v.FrameRate = 10 ;
    %  v.Quality = 100;
    open(v);



min_d = min(Tdata(4:6,:),[],2).*1000 ;
max_d = max(Tdata(4:6,:),[],2).*1000 ;
for t = 1:20:size(timeSteps,2)
    Figure(4);
    cla
    for s = 1:size(no_swimmer,2)
        
        cond = Tdata(1,:) == time(t) & Tdata(2,:) == no_swimmer(s) ;
        cond_swimer = Tdata(2,:) == no_swimmer(s) & Tdata(3,:) == 1 ;
        
        plotSPoints = Tdata(4:6,cond_swimer).*1000   ;
        
        plotTPoints = Tdata(4:6,cond).*1000 ;
        
        switch swimmerType
            case 'Two-Bead'
                
                plotPoints = plotTPoints;
            case 'Three-Bead'
                
                plotPoints = [plotTPoints(:,2) plotTPoints(:,1) plotTPoints(:,3)] ;
                
        end
        
        
        
        
        plot3(plotPoints(1,:),plotPoints(2,:),plotPoints(3,:),'k-o','Linewidth',2)
        hold on
       
        plot3(plotSPoints(1,t_start_interaction:t),plotSPoints(2,t_start_interaction:t),plotSPoints(3,t_start_interaction:t),'g-','Linewidth',2)
            
        surf(sX2+plotTPoints(1,1),sY2+plotTPoints(2,1),sZ2+plotTPoints(3,1),'FaceColor',[0 0.6 0],'LineStyle','-','EdgeColor',[0 0.5 0])
        switch swimmerType
            case 'Two-Bead'
                surf(sX3+plotTPoints(1,2),sY3+plotTPoints(2,2),sZ3+plotTPoints(3,2),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
            case 'Three-Bead'
                surf(sX3+plotTPoints(1,2),sY3+plotTPoints(2,2),sZ3+plotTPoints(3,2),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
                surf(sX3+plotTPoints(1,3),sY3+plotTPoints(2,3),sZ3+plotTPoints(3,3),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
        end
        % %
    end
    xlim([min_d(1)-10 max_d(1)+10])
	ylim([min_d(2)-10 max_d(2)+10])
	zlim([min_d(3)-10 max_d(3)+10])
    
%     xlim([-50 +50])
%     ylim([-10 10])
%     zlim([-60 200])
    
    
    xlabel('$\mu m$')
    ylabel('$\mu m$')
    zlabel('$\mu m$')
    camproj perspective
    axis equal
    setFigureProperty(30,30,20,15,1.5,20,'latex');
    view(0,0)
    if strcmp(video_make,'on')
        drawnow
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end
    close(v);

end

if strcmp(plot_interaction,'on')
    min_d = min(Tdata(4:6,:),[],2) ;
    max_d = max(Tdata(4:6,:),[],2) ;
    position_swimmer_bead = cell(1,2) ;
    marker_s = {[0.4660 0.6740 0.1880],[0.8500 0.3250 0.0980]} ;
    marker_p = {[0 0.6 0],[0.6 0 0]} ;
    marker_q = {[0 0.5 0],[0.5 0 0]} ;
    
    h1=figure;
    h1.Color=[1 1 1];
    h1.Units= 'normalized';
    h1.OuterPosition=[0.1 0.1 0.8 0.8];
    clf
    
    for s = 1:size(no_swimmer,2)
        
        % Figure 1
        
        cond_t_1 =  Tdata(1,:)== time(1) & Tdata(2,:) == no_swimmer(s) ;
        cond_t_end = Tdata(1,:)==time(end) & Tdata(2,:) == no_swimmer(s) ;
        cond_swimer = Tdata(2,:) == no_swimmer(s) & Tdata(3,:) == 1 ;
        plotSPoints = Tdata(4:6,cond_swimer).*1000   ;
        
       
        
        
        plotTPoints = Tdata(4:6,cond_t_1).*1000 ;
        plotTPointsEnd = Tdata(4:6,cond_t_end).*1000 ;
        
        switch swimmerType
            case 'Two-Bead'
                
                plotPointsStart = plotTPoints;
                plotPointsEnd = plotTPointsEnd;
            case 'Three-Bead'
            
                 plotPointsStart = [plotTPoints(:,2) plotTPoints(:,1) plotTPoints(:,3)] ;
                plotPointsEnd = [plotTPointsEnd(:,2) plotTPointsEnd(:,1) plotTPointsEnd(:,3)] ;
        end
        

        plot3(plotPointsStart(1,:),plotPointsStart(2,:),plotPointsStart(3,:),'k-o','Linewidth',2)
        hold on
        plot3(plotPointsEnd(1,:),plotPointsEnd(2,:),plotPointsEnd(3,:),'k-o','Linewidth',2)
        plot3(plotSPoints(1,:),plotSPoints(2,:),plotSPoints(3,:),'-','Color',marker_s{s},'Linewidth',1)
%         plot3(plotSPoints2(1,1:idx_100),plotSPoints2(2,1:idx_100),plotSPoints2(3,1:idx_100),'--','Color',marker_s{s},'Linewidth',1.5)
        surf(sX2+plotTPoints(1,1),sY2+plotTPoints(2,1),sZ2+plotTPoints(3,1),'FaceColor',marker_p{s},'LineStyle','-','EdgeColor',marker_q{s})
        surf(sX2+plotTPointsEnd(1,1),sY2+plotTPointsEnd(2,1),sZ2+plotTPointsEnd(3,1),'FaceColor',marker_p{s},'LineStyle','-','EdgeColor',marker_q{s})
         
          switch swimmerType
            case 'Two-Bead'
                 surf(sX3+plotTPoints(1,2),sY3+plotTPoints(2,2),sZ3+plotTPoints(3,2),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
                 surf(sX3+plotTPointsEnd(1,2),sY3+plotTPointsEnd(2,2),sZ3+plotTPointsEnd(3,2),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')

              case 'Three-Bead'
                  surf(sX3+plotTPoints(1,2),sY3+plotTPoints(2,2),sZ3+plotTPoints(3,2),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
                  surf(sX3+plotTPoints(1,3),sY3+plotTPoints(2,3),sZ3+plotTPoints(3,3),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
                  surf(sX3+plotTPointsEnd(1,2),sY3+plotTPointsEnd(2,2),sZ3+plotTPointsEnd(3,2),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
                  surf(sX3+plotTPointsEnd(1,3),sY3+plotTPointsEnd(2,3),sZ3+plotTPointsEnd(3,3),'FaceColor',[0.42 0.42 0.42],'LineStyle','none')
                  
          end

        
    end
    % Figure(1)
    camproj perspective
    box on
    grid on
    view(3)
    set(gca,'TickDir','in','TickLabelInterpreter','latex', ...
        'AmbientLightColor',[0 0 1],'ClippingStyle',...
        'rectangle','Color',[1 1 1],'Layer','top',...
        LineWidth=0.5,FontSize=20)
    hAxis = gca;
    axis equal
    view(3)

    drawnow
end


end
