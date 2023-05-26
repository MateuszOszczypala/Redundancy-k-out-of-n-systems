p = 0.981920903954802;
q = 1-p;
n = 19;
mu = 3.8344;
sigma = 2.0762;
Rs = zeros(1,n);
for x = 1:n
    R_kx_i = 0;
    for k = 1:x
        R_kx = 0;
        for i = k:x
            R_kx_i = nchoosek(x,i)*(p^i)*(q^(x-i));
            R_kx = R_kx + R_kx_i;
        end
        Rs(1,x) = Rs(1,x) + R_kx * (cdf("Logistic", k+0.5, mu, sigma)-cdf("Logistic", k-0.5, mu, sigma));
    end
     R_kx = 0;
        for i = 0:x
            R_kx_i = nchoosek(x,i)*(p^i)*(q^(x-i));
            R_kx = R_kx + R_kx_i;
        end
            Rs(1,x) = Rs(1,x) + R_kx*cdf("Logistic", 0.5, mu, sigma);
end

l = figure;
plot([0 n+0.5], [1 1], 'LineStyle','--','Color','black','LineWidth',0.5);
hold on
N = 1:1:n;
plot(N, Rs, 'LineWidth',1.5,'Color','red');
xlabel('Number of components');
ylabel('System Reliability');
xticks(1:1:n);
axis([0  n+0.5 0 1.1]);
fontsize(gca,12,"pixels");
set(gcf,'units','centimeters','position',[10,10,16,8]);
set(gca,'units','centimeters','position',[1.3,1.3,14.5,6.5]);
saveas(l,sprintf('System Reliability Method2 cs1')); % save created plot
