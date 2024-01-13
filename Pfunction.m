function [ Pvals ] = Pfunction(x,xdata,maturities )
%PFUNCTION Summary of this function goes here
% Produce the bond prices given the input of parameters and data
% and the maturities of bonds  
rbar=x(1);
gamma=x(2);
alpha=x(3);

Avals=Afunction(rbar, gamma, alpha, maturities);
Bvals=Bfunction(rbar, gamma, alpha, maturities);

Pvals=zeros(length(xdata), length(maturities)); % Dvals is a T by d matrix

% Two approaches to give the prices of bonds 
% The first appraoach: for each instanteneous interest rates and
% calculate the yield cuve. You need a loop 
for i=1:length(xdata) % Length of the data set T
    % xdata(i) is r_0 is T by 1 
    Pvals(i,:)=100*exp(Avals- Bvals.*xdata(i)); % 100 is the face value of bonds
end

% The second approach is more efficient in MATLAB that uses element-wise matrix
% multiplication
Pvals=100*exp(Avals- Bvals.*xdata);

end

