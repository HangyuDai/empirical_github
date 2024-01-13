clear
close all
crsp=readtable('crsp_port.csv');
Rf=readtable('Rf_mkt.CSV');

crsp.yymm=12*year(crsp.date)+month(crsp.date);
crsplag=crsp;
crsplag.yymm=crsplag.yymm-1;
crsplag.ereturn=crsplag.retadj;

crsplag.wt=crsplag.me;

crsp=innerjoin(crsp,crsplag(:,{'ereturn','yymm','permno','wt'}),'Keys',{'yymm','permno'});

% Merge
Rf.yymm=floor(Rf.Var1/100)*12+mod(Rf.Var1,100)-1;
Rf.Mkt_RF=Rf.Mkt_RF/100;
Rf.RF=Rf.RF/100;
crsp1=innerjoin(crsp,Rf(:,{'RF','yymm'}),'Keys','yymm');
crsp1.ereturn=crsp1.ereturn-crsp1.RF;

%Portfolio Analysis
crsp1.sortvar=crsp1.me;
%crsp1.sortvar=crsp1.beme;

flexsort_5=@(x){flexsort(x,5)};
[G_date,jdate]=findgroups(crsp1.date);

var_sort=cell2mat(splitapply(flexsort_5,crsp1.sortvar,G_date));

[G_port,jdate,portgroup]=findgroups(crsp1.date,var_sort);
wavg_fun=@(x,y)wavg(x,y);

Port_return=splitapply(wavg_fun,crsp1.ereturn,crsp1.wt,G_port);

Port_return_table=table(jdate,portgroup,Port_return);

Port_return_res =unstack(Port_return_table...
    (:,{'jdate','portgroup','Port_return'}),'Port_return','portgroup');


Port_return_res.yymm=year(Port_return_res.jdate)*12+month(Port_return_res.jdate);
Port_return_res=innerjoin(Port_return_res...
    ,Rf(:,{'yymm','Mkt_RF'}),'Keys','yymm');

Port=table2array(Port_return_res(:,2:6));
Spread=Port(:,5)-Port(:,1);
Sharpe=mean(Port)./std(Port);
%Figuring
figure;
subplot(2,2,1);
plot(Port);
xlim([1 length(Port)])
title('Excess Return')

subplot(2,2,2);
Annual_return=(geomean(Port+1)-1)*12;
bar(Annual_return)
title('Annualized Excess Return')

subplot(2,2,3)
plot(Spread)
title('Spread Between Portfolios')
xlim([1 length(Port)])

subplot(2,2,4);
bar(Sharpe)
title('Sharpe Ratio')

sgtitle('Sort by size')


%% Cumulative Returns (additional)

dataFile = 'crsp_port.csv';
crsp_table = readtable(dataFile);
[G,permno] = findgroups(crsp_table.permno);
r_cum = splitapply(@cumulativeReturn,crsp_table.retadj,G);
firmReturn = table(permno,r_cum);

% for loop
crsp = sortrows(crsp_table,{'permno','date'},{'ascend','ascend'});
cum_r = cell(length(permno),1);
final_r = cell(length(permno),1);
disp(cum_r)
disp(final_r)

for i=1:length(permno)
    retadj = crsp(crsp.permno==permno(i),:).retadj;
    cum_return = cumprod(retadj+1)-1;
    cum_r(i) = mat2cell(cum_return,length(cum_return));
    final_r(i) = {cum_return(end)};
end
cum_return_loop = table(permno,cum_r,final_r);

disp(cum_return_loop)