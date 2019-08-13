function phis=plotNodes(all_nodes, cc)

    subaxis(1,1,1,'PaddingTop',.08,'PaddingBottom',.01)

    numColors=length(cc);
    minPhi=.95;
    maxPhi=1.05;
    maxDensity=0;
    ns=length(all_nodes);
    for s=1:ns
        nodes=all_nodes{s};
        N=length(nodes);
        for i=1:N
            thisDensity=nodes{i}.y(end,3)+nodes{i}.y(end,4);
            if thisDensity>maxDensity
                maxDensity=thisDensity;
            end

        end
    end

    phis=zeros(ns, length(all_nodes{1}));

    for s=1:ns
        nodes=all_nodes{s};
        N=length(nodes);

        %Plot horizontal lines
        if s>1
            plot([0.25 N+.7],[s s],'-','LineWidth',2*(s-1),'Color',[.9 .9 .9]);hold on;
        end

        for i=1:N

            if s==ns
                text(i,.15,num2str(i-1),'HorizontalAlignment','center','FontSize',20);
            end

            center=[i,s];

            rmax=.5;
            relDensity=(nodes{i}.y(end,3)+nodes{i}.y(end,4))/maxDensity;  %Bs+Br
            r=relDensity*rmax;

            phi=phiR(nodes{i}.y(:,3),nodes{i}.y(:,4));
            %phi=relFitness(nodes{i}.y(:,3),nodes{i}.y(:,4));
            phi=phi(end);
            if phi<minPhi
                phi=minPhi;
            elseif phi>maxPhi
                phi=maxPhi;
            end

            icc=floor(interp1(linspace(minPhi,maxPhi,numColors),linspace(1,numColors,numColors),phi));

            filledCircle(center,r,1000,cc(icc,:),1); hold on;

        end

    end

    set(gcf, 'Colormap', flipud(cc));
    cbh=colorbar('Location','NorthOutside');
    %set(cbh, 'xlim', [minPhi/2 maxPhi/2])
    %pos=get(gca,'Position');
    cbhpos=get(cbh,'Position');
    cbhpos(3)=.5*cbhpos(3);
    cbhpos(1)=cbhpos(1)+0.1*cbhpos(3);
    cbhpos(2)=.88;
    set(cbh,'Position',cbhpos)
    %cbhl=get(cbh,'XTick');
    set(cbh,'XTick',[0 .5 1])
    set(cbh,'XTickLabel',[minPhi 1 maxPhi],'FontSize',20)
    text((N+1)/3, 1.09*ns,'Relative fitness, \phi_r','FontSize',24,'HorizontalAlignment','center');
end