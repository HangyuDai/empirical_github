function [ Pvals ] = CIRCouponBond(parameters,r0, timetoMaturity, couponRate)
%CIR Coupon FUNCTION returns the price of coupon bonds given
% CIR model parameters, current instanteneous interest rates, 
% and models 
% given the input of parameters and data
% and the maturities of bonds  
rbar=parameters(1);
gamma=parameters(2);
alpha=parameters(3);

if mod(timetoMaturity,0.5)~=0
disp('Warning: the function does not accomodate timetoMaturity measured not in half a year !!!!! \n')
else 

% Vectorize the time-to-maturity of each payment of this coupon bond
maturityVec=[0.5:0.5:timetoMaturity];
Avals=Afunction(rbar, gamma, alpha, maturityVec);
Bvals=Bfunction(rbar, gamma, alpha, maturityVec);

faceValue=100;

singleCoupon=faceValue*couponRate/2; % A single coupon paid every 6 months

payoffVec=singleCoupon*ones(1,2*timetoMaturity); % The payoff vector of coupon bonds.
payoffVec(end)=payoffVec(end)+faceValue; % At the end, the coupon bond pays back the principle.

Pvals=payoffVec.*exp(Avals- Bvals.*r0);


end 
end

