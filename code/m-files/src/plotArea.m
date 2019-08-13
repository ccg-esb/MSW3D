function phis=plotArea(all_nodes, cc)

    subaxis(1,1,1,'PaddingTop',.08,'PaddingBottom',.01)

    minPhi=.95;
    maxPhi=1.05;
    maxDensity=0;
    ns=length(all_nodes);
    
    dist=0:ns;
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

    
    separatrix=N*ones(1,ns);
    for s=1:ns
        nodes=all_nodes{s};
        N=length(nodes);

     
        iflip=N;
        for i=1:N

            center=[i,s];

            rmax=.5;
            relDensity=(nodes{i}.y(end,3)+nodes{i}.y(end,4))/maxDensity;  %Bs+Br
            r=relDensity*rmax;

            phi=phiR(nodes{i}.y(:,3),nodes{i}.y(:,4));
            phi=phi(end);
            if phi<minPhi
                phi=minPhi;
            elseif phi>maxPhi
                phi=maxPhi;
            end
            
            if i>1
                if phi>=1 && iflip==N
                    
                    iflip=i;
                    separatrix(s)=iflip;
                end
            end

            
        end

    end
    
    x1=[0 dist(separatrix) N];
    y1=[0:ns ns];
    
    plot(x1, y1,  'r-','LineWidth',2);
    
    rectangle('Position',[0 0 N ns],'FaceColor','c'); hold on;
    area(x1, y1, 'FaceColor','y');
    plot(x1, y1, 'k-','LineWidth',2);
    axis([0 N-1 0 ns]);

end

%%
