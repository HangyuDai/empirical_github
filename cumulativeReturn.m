%This function is used to calculate the cumulative return of a stock
function r_cum = cumulativeReturn(rm)
% rm is the vector of monthly return
%r_cum is the cumulative return across the corresponding period of rm
r_cum = 1;

for i=1:length(rm)
    r_cum = r_cum*(1+rm(i));
end
r_cum = r_cum -1;
end