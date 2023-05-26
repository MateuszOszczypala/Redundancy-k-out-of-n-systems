clear;
clc;
% input data
time_simulation = 10000; % time of simulation
vehicles = 19; % max number of vehicles in transportation system
lambda = 0.0048; % failure intensity
mi = 0.2607; % renewal intensity
mu = 3.8344; % k
sigma = 2.0762; %f k
sens = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1 2 3 4 5 6 7 8 9 10];
n_opt = 10;
I = 1:1:time_simulation; % discreat time for k-out-of-n simulation
        
        n = 1;    
        time = 0; % time variable
        S = n_opt; % state in t = 0;    
        X_t(n) = S; % initial state
        T_t(n) = 0; % initial time
        t = 1; % number of transition
        while time < time_simulation
            t = t + 1;
            if S == n_opt % failure
                    p = rand(1,1);
                    t_f = -log(1-p)/(lambda*S);
                    time = time + t_f;
                    S = S - 1;
            elseif S == 0  % renewal
                    q = rand(1,1);
                    t_r = -log(1-q)/(mi*(n_opt-S));
                    time = time + t_r;
                    S = S + 1;
            else % failure and renewal
                    p = rand(1,1);
                    q = rand(1,1);
                    t_f = -log(1-p)/(lambda*S);
                    t_r = -log(1-q)/(mi*(n_opt-S));
                    if t_f > t_r
                        time = time + t_r;
                        S = S + 1;
                    else
                        time = time + t_f;
                        S = S - 1;
                    end
            end
            T_t(t) = time;
            X_t(t) = S;
        end  
                    X_d = n_opt.*ones(time_simulation);
                    j = 1;
                for m = 1:length(X_t)
                    while j < time_simulation + 1
                        if T_t(m) < j
                            if T_t(m+1) > j - 1
                                X_t_d(j) = X_t(m);
                                if X_t_d(j) < X_d(j)
                                    X_d(j) = X_t_d(j);
                                end
                            end
                        end
                        j = j + 1;
                    end
                    j = 1;
                end
for s = 1:19
    mu1 = mu * sens(s);
    for l = 1:19
        sigma1 = sigma * sens(l);
     for j = 1:time_simulation % sampling k-out-of-n
           p_k = rand(1,1);
           k = icdf('Logistic',p_k, mu1, sigma1); % logistic distribution with parameters mu and sigma
           if k < 0
               k = 0;
           end
           K_k(j) = round(k); % rounding to integers
     end
                % Technical Performance Measure
                    for b = 1:time_simulation
                        if X_d(b) >= K_k(b)
                            TPM(b) = 1;
                        else
                            TPM(b) = X_d(b)/K_k(b);
                        end                   
                    end
                    mean_TPM(s,l) = mean(TPM);
                    %Reliability                    
                        for b = 1:time_simulation
                            if X_d(b) >= K_k(b)
                                R(b) = 1;
                            else
                                R(b) = 0;
                            end
                        end
                        mean_Reliability(s,l) = sum(R(:))/time_simulation; 
                       
    end
end
[X,Y] = meshgrid(mu*sens, sigma*sens);
h1 = figure;
surf(X',Y',mean_Reliability);
fontsize(gcf,12,"pixels");
colormap(jet(200));
ylabel('\it\sigma');
xlabel('\it\mu');
zlabel('System Reliability');
shading interp
colorbar;
set(gcf,'units','centimeters','position',[10,10,10,8]);
set(gca,'units','centimeters','position',[1.1,1,6.5,6.8]);
saveas(h1,sprintf('System Reliability Sensitivity Analysis')); % save created plot
close(h1);
h2 = figure;
surf(X',Y',mean_TPM);
fontsize(gcf,12,"pixels");
colormap(jet(200));
ylabel('\it\sigma');
xlabel('\it\mu');
zlabel('Technical Performance Measure');
shading interp
colorbar;
set(gcf,'units','centimeters','position',[10,10,10,8]);
set(gca,'units','centimeters','position',[1.1,1,6.5,6.8]);
saveas(h2,sprintf('TPM Sensitivity Analysis')); % save created plot
close(h2);



