function node=simulateNode(x0, params)


    %%%%%%%%%%%% SIMULATE
    [t,y] = ode15s(@(t,x)f2types(x,params,[0,0],[0,0]),[0,params.T],x0);

    node.i=1;
    node.time=t;
    node.y=y;
    node.phi=0;
    %node.phi=relFitness(y(:,3),y(:,4));
