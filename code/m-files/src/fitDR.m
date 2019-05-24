function [xFit,yFit]=fitDR(X,Y)

    [cf,G]=L4P(1+X', 1-Y');
    xFit=linspace(X(1),X(end),100);
    yFit = 1-arrayfun(@(x) cf.D+(cf.A-cf.D)/(1+(x/cf.C)^cf.B),xFit+1);
    