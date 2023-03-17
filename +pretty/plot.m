function plot(figure_name,figure_size)


f=gcf;


% some basics
f.Color = 'w';
f.InvertHardcopy = 'off' ;
f.WindowStyle = 'normal' ;

% clean menu bars
f.DockControls = 'off' ;
f.MenuBar = 'none' ;
f.NumberTitle = 'off' ;
f.ToolBar = 'none' ;

% printing
f.PaperPositionMode = 'manual';
f.PaperUnits = 'centimeters' ;
f.PaperType = 'a4' ;
f.PaperPosition = [0 0 figure_size] ; % left bottom width height

f.Units = 'centimeters';
f.Position(3:4) = figure_size;

% loop through axes
for a=findobj(f,'Type','Axes')'
    
    a.Box = 'off';
    a.Color = 'none' ;
    
    a.LineWidth=2 ;
    a.FontName = 'Verdana' ;
    a.FontSize = 12 ;
    
    a.TickDirMode = 'manual';
    a.TickDir = 'out';
    a.TickLength = [.02 .05] ;
    
    a.XLabel.FontWeight = 'bold';
    a.XLabel.FontSize = 14 ;
    
    a.YLabel.FontWeight = 'bold';
    a.YLabel.FontSize = 14 ;
    
    a.ZLabel.FontWeight = 'bold';
    a.ZLabel.FontSize = 14 ;
    
    a.Title.FontSize=15;
    a.Title.Units = 'normalized';
    a.Title.Position = [-.15 1.05 0 ];
    a.Title.HorizontalAlignment = 'left';
    
    for l=findobj(a,'Type','Line')'
        l.LineWidth=2.2;
        bw = .02 * (a.XLim(2) - a.XLim(1));
    end
    
    for l=findobj(a,'Type','Text')'
        l.FontSize = 12;
        l.FontWeight = 'bold';
    end
    
    for b=findobj(a,'Type','Bar')'
        b.LineStyle='none';
        b.BaseLine.LineStyle = '-';
        b.BaseLine.LineWidth=1;
        b.BaseLine.Color=.3*[1 1 1];
        b.BarWidth=.9;
        bw = .35*b.BarWidth;
    end
    
    for e=findobj(a,'Type','ErrorBar')'
        
        XDATA = e.XData;
        YDATA_d = e.YData-e.LData;
        YDATA_u = e.YData+e.UData;
        color = e.Color;
        delete(e) ;
        
        for iL=1:numel(XDATA)
            l=line(a,XDATA([iL iL]), [YDATA_d(iL) YDATA_u(iL)]);
            l.LineWidth=1;
            l.Color = color;
            l.ZData=[-1 -1];
            
            %if ~isempty(findobj(a,'Type','Bar'))
            color=.25*[1 1 1];
            l.Color = color;
            l=line(a,XDATA([iL iL]) + [-bw bw], [YDATA_u(iL) YDATA_u(iL)]);
            l.LineWidth=1;
            l.Color = color;
            l.ZData=[-1 -1];
            l=line(a,XDATA([iL iL]) + [-bw bw], [YDATA_d(iL) YDATA_d(iL)]);
            l.LineWidth=1;
            l.Color = color;
            l.ZData=[-1 -1];
            
            
            %end
        end
    end
    
    if strcmp(a.ZGrid,'on')
        a.Box='on';
        a.GridAlpha=.05;
        %a.Position = a.Position + [-.01 -.015 +.01 +.015];
    end
    % a.XGrid = 'off';
    % a.YGrid = 'off';
    % a.ZGrid = 'off';
    
    boxes = findobj(a,'Tag','boxplot');
    if ~isempty(boxes)
        
        [boxes.Children.LineStyle] = deal('-');
        [boxes.Children.LineWidth] = deal(1.5);
        
        h = findobj(boxes,'Tag','Box');
            for j=1:length(h)
                p=patch(a,get(h(j),'XData'),get(h(j),'YData'),h(j).Color,'EdgeColor','none');
                p.ZData = -ones(size(p.XData));
                delete(h(j));
            end
        h = findobj(boxes,'Tag','Median');
        [h.Color] = deal([1 1 1]);
        [h.LineWidth] = deal(1.5);
        
        
        h = findobj(boxes,'Tag','Upper Whisker');
        [h.Color] = deal(.2*[1 1 1]);
        [h.LineWidth] = deal(1);
        h = findobj(boxes,'Tag','Lower Whisker');
        [h.Color] = deal(.2*[1 1 1]);
                [h.LineWidth] = deal(1);
 h = findobj(boxes,'Tag','Lower Adjacent Value');
        [h.Color] = deal(.2*[1 1 1]);
                [h.LineWidth] = deal(1);

 h = findobj(boxes,'Tag','Upper Adjacent Value');
        [h.Color] = deal(.2*[1 1 1]);
                [h.LineWidth] = deal(1);


        % deal with outliers
        outliers = findobj(boxes,'Tag','Outliers');
        [outliers.LineStyle] = deal('none');
        [outliers.Marker] = deal('o');

    end
    
end
print(figure_name,'-dsvg','-painters','-r600') ;
% try
%     [~,~] = system(sprintf(' /Applications/Inkscape.app/Contents/Resources/bin/inkscape -z  -d 600 $(pwd)/%s.svg  -A $(pwd)/%s.pdf',figure_name,figure_name));
% end
end

function demo
titleList = {'A','B','C','D'};
for i=1:4
    subplot(2,2,i);
    
    switch i
        case 1
            r = 5*randn(3);
            plot(r);
            hold on
            errorbar(r,ones(3));
            xlim([1 3])
        case 2
            r = 5*randn(2);
            h=bar(r);
            hold on
            of=[h.XOffset];
            errorbar([1+of 2+of],vec(r'),[1 1 1 1]);
            
        case 3
            r = 5*randn(16);
            r2 = 5*randn(16);
            plot(r,r2,'.','Color',[.2 .2 .2]);
            xlim([1 3])
        case 4
            r = 5*randn(20);
            imagesc(r);
            
    end
    
    xlabel('x values (unit)');
    ylabel('y values (unit)');
    title(titleList{i})
end
end
