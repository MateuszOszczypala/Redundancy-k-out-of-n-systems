% data for estimation Kaplan-Meier
x = datarepair(:,1);
cens = datarepair(:,2);
[f,y] = ecdf(x, 'Censoring', cens, 'Function','cdf'); %cdf
[g,z] = ecdf(x,"Censoring",cens,"Function","survivor"); %1-cdf
aprox = fit(z,g,'exp1','Lower',[1 -Inf],'Upper',[1 Inf],'StartPoint',[1 -0.004]);
%plot(aprox,z,g);
%close();
h = figure();
stairs(y,f,'LineWidth',1.2);
xlabel('{\itt} (day)', FontSize=11);
ylabel('{\itG}({\itt})', FontSize=11);
fontsize(gca,11,"pixels");
set(gcf,'units','centimeters','position',[10,10,8,8]);
set(gca,'units','centimeters','position',[1,1,6.8,6.8]);
hold on
t = linspace(0,max(x),1000);
exp_model = 1 - exp(aprox.b .* t);
plot(t, exp_model,'LineWidth',1,'Color','black');
axis([0 max(x) 0 1]);
legend('Kaplan-Meier estimation','Exponential',Location='southeast');

mu = -aprox.b;
Pearson = corr(f,1 - exp(aprox.b .* y));
MSE = immse(f,1 - exp(aprox.b .* y));

annotation('textbox', [0.60, 0.35, 0.1, 0.1], 'String', "{\it\rho} = "+round(Pearson,4),'EdgeColor','none','FontSize', 9);
annotation('textbox', [0.60, 0.30, 0.1, 0.1], 'String', "{\it{MSE}} = "+round(MSE,4),'EdgeColor','none','FontSize', 9);
annotation('textbox', [0.60, 0.25, 0.1, 0.1], 'String', "{\it\mu} = "+round(mu,4)+" day^-^1",'EdgeColor','none','FontSize', 9);
saveas(h, 'Kaplan_Meier_estimation_of_repair_cdf','fig');
%close (h);
