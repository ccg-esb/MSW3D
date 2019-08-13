function phis=plotNodesSmall(all_nodes, cc)

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

     

        for i=1:N

            if s==ns && (i==6 || i==1 || i==11)
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

end