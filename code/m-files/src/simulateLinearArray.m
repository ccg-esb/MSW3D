function nodes=simulateLinearArray(x0, params)

    nodes={};
    
    nT=100;
    deltaT=1/nT;
    
    for d=1:nT

        for i=1:params.N
            
            
            %%%%%%%%%%%% DIFFUSE
            if d==1  %From initial conditions
                if i>1
                    Aiminus1=x0(i-1,2);
                    Riminus1=x0(i-1,1);
                else
                    Aiminus1=NaN;
                    Riminus1=NaN;
                end

                if i<params.N
                    Aiplus1=x0(i+1,2);
                    Riplus1=x0(i+1,1);
                else
                    Aiplus1=NaN;
                    Riplus1=NaN;
                end
            else  %From previous deltaT
                if i>1
                    Aiminus1=nodes{i-1}.y(end,2);
                    Riminus1=nodes{i-1}.y(end,1);
                else
                    Aiminus1=NaN;
                    Riminus1=NaN;
                end

                if i<params.N
                    Aiplus1=nodes{i+1}.y(end,2);
                    Riplus1=nodes{i+1}.y(end,1);
                else
                    Aiplus1=NaN;
                    Riplus1=NaN;
                end
            end

            %%%%%%%%%%%% SIMULATE
            [ti,yi] = ode15s(@(t,x)f2types(x,params,[Riplus1, Riminus1],[Aiplus1, Aiminus1]),[(d-1)*deltaT d*deltaT],x0(i,:));
           
            t=(ti).*params.T;
            y=yi;
            
            if d==1
                node.i=i;
                node.time=t;
                node.y=y;
            else
                node.i=i;
                node.time=[nodes{i}.time; t];
                node.y=[nodes{i}.y; y];
            end
            
            nodes{i}=node;
            node={};
            x0(i,:)=yi(end,:);
            
            
        end
    end