% data for k
x = sort(k);
n = length(k);
p = ((1:n)-0.3)'./(n+0.4);
h = figure();
stairs(x,p,'k-','Color','blue',LineWidth=1.2);
set(gcf,'units','centimeters','position',[10,10,12,6]);
set(gca,'units','centimeters','position',[1,1,10.7,4.7]);
xlabel('{\itk}');
ylabel('CDF');
hold on
z = 0:0.01:50;
Normal = fitdist(x, 'Normal');
Normal_plot = cdf(Normal,z);
Normal_cdf = cdf(Normal,x);
plot (z, Normal_plot,'Color','red',LineWidth=1.2);
Logistic = fitdist(x, 'Logistic');
Logistic_plot = cdf(Logistic,z);
Logistic_cdf = cdf(Logistic,x);
plot (z, Logistic_plot,'Color','black',LineWidth=1.2);

%plot (z, GEV_plot,'Color','green',LineWidth=1);
legend('Empirical', 'Normal', 'Logistic','Location','southeast');
fontsize(gca,11,'pixels');
set(gcf,'units','centimeters','position',[10,10,12,6]);
set(gca,'units','centimeters','position',[1,1,10.7,4.7]);
saveas(h, 'cdf_of_k','fig');
close (h);

Pearson_Normal = corr(p,Normal_cdf);
Pearson_Logistic = corr(p,Logistic_cdf);

MSE_Normal = immse(p,cdf(Normal,x));
MSE_Logistic = immse(p,cdf(Logistic,x));