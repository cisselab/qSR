function [X_exp,Z_exp]=ExpectedBackground(Nuclear_Frames,area_ratio)

    X_exp=min(Nuclear_Frames):max(Nuclear_Frames);
    Y=zeros(size(X_exp));
    for i = 1:length(X_exp)
        Y(i)=sum(Nuclear_Frames==X_exp(i));
    end
    
    Y_exp=Y*area_ratio;
    Z_exp=cumsum(Y_exp);
