clear;
clc;
% input data
time_simulation = 10000; % time of simulation
vehicles = 19; % max number of vehicles in transportation system
lambda = 0.0048; % failure intensity
mi = 0.2607; % renewal intensity
mu = 3.8344; % k
sigma = 2.0762; %f k
for n = 1:vehicles
    time = 0; % time variable
    S = n; % state in t = 0;    
    X_t(n,1) = S; % initial state
    T_t(n,1) = 0; % initial time
    t = 1; % number of transition
    while time < time_simulation
        t = t + 1;
        if S == n % failure
                p = rand(1,1);
                t_f = -log(1-p)/(lambda*S);
                time = time + t_f;
                S = S - 1;
        elseif S == 0  % renewal
                q = rand(1,1);
                t_r = -log(1-q)/(mi*(n-S));
                time = time + t_r;
                S = S + 1;
        else % failure and renewal
                p = rand(1,1);
                q = rand(1,1);
                t_f = -log(1-p)/(lambda*S);
                t_r = -log(1-q)/(mi*(n-S));
                if t_f > t_r
                    time = time + t_r;
                    S = S + 1;
                else
                    time = time + t_f;
                    S = S - 1;
                end
        end
        T_t(n,t) = time;
        X_t(n,t) = S;
    end  
end
 I = 1:1:time_simulation; % discreat time for k-out-of-n simulation
 for j = 1:time_simulation % sampling k-out-of-n
       p_k = rand(1,1);
       k = icdf('Logistic',p_k, mu, sigma); % logistic distribution with parameters mu and sigma
       if k < 0
           k = 0;
       end
       K_k(j) = round(k); % rounding to integers
 end
for m = 1:vehicles
    for i = 1:length(T_t)-1
        if T_t(m,length(T_t)-i+1) <= T_t(m,length(T_t)-i)
            T_t(m,length(T_t)-i+1) = NaN; % change 0 to NaN
            X_t(m,length(T_t)-i+1) = NaN; % change 0 to NaN
        end
    end
    h = figure;
    stairs(I,K_k, "LineWidth", 1);
    xlabel('Time (days)');
    ylabel('Number of components');
    y = max([max(K_k),m]);
    axis([0  time_simulation 0 y+0.5]);
    hold on
    stairs(T_t(m,:),X_t(m,:), "LineWidth", 1);
    legend('{\itk}-out-of-{\itn}','Components in suitability state','Location','southoutside');
    set(gcf,'units','centimeters','position',[10,10,16,8]);
    set(gca,'units','centimeters','position',[1.1,2.15,14.3,5.7]);
    fontsize(gca,11,"pixels");
    saveas(h,sprintf('Number_of_vehicles_%d.fig',m)); % save created plot
    close(h); % close plot
end
X_d = vehicles.*ones(vehicles,time_simulation);
for i = 1:vehicles %Change continuous to discrete
    %l = 1;
    j = 1;
    for m = 1:length(X_t(i,:))
        while j < time_simulation + 1
            if T_t(i,m) < j
                if T_t(i,m+1) > j - 1
                    X_t_d(i,j) = X_t(i,m);
                    if X_t_d(i,j) < X_d(i,j)
                        X_d(i,j) = X_t_d(i,j);
                    end
                end
            end
            j = j + 1;
        end
        j = 1;
    end    

end
% Technical Performance Measure
for a = 1:vehicles
    for b = 1:time_simulation
        if X_d(a,b) >= K_k(b)
            TPM(a,b) = 1;
        else
            TPM(a,b) = X_d(a,b)/K_k(b);
        end
    end
end
%Reliability
for a = 1:vehicles
    for b = 1:time_simulation
        if X_d(a,b) >= K_k(b)
            R(a,b) = 1;
        else
            R(a,b) = 0;
        end
    end
    Reliability(a) = sum(R(a,:))/time_simulation;
end
%Plot and boxplot of Technical Performance Measure
trTPM = TPM.';
for z = 1:vehicles
    mean_odtpm(z) = mean(trTPM(1:time_simulation,z));
end
g = figure;
plot(1:vehicles, mean_odtpm, 'LineWidth',1.2, 'Color','black');
legend('Mean value for{\it n}-component system',Location='southeast');
hold on
boxplot(TPM.','MedianStyle','target','OutlierSize',2);
xlabel('Number of components');
ylabel('Technical Performance Measure');
axis([0  vehicles+0.5 0 1.1]);
fontsize(gca,12,"pixels");
set(gcf,'units','centimeters','position',[10,10,16,8]);
set(gca,'units','centimeters','position',[1.3,1.3,14.5,6.5]);
saveas(g,sprintf('Technical Performance Measure')); % save created plot
close(g); % close plot

%Plot of Reliability
l = figure;
c = 1:1:vehicles;
plot([0 vehicles+0.5], [1 1], 'LineStyle','--','Color','black','LineWidth',0.5);
hold on
plot(c, Reliability, 'LineWidth',1.5,'Color','blue');
xlabel('Number of components');
ylabel('System Reliability');
xticks(1:1:vehicles);
axis([0  vehicles+0.5 0 1.1]);
fontsize(gca,12,"pixels");
set(gcf,'units','centimeters','position',[10,10,16,8]);
set(gca,'units','centimeters','position',[1.3,1.3,14.5,6.5]);
saveas(l,sprintf('System Reliability')); % save created plot
close(l); % close plot

