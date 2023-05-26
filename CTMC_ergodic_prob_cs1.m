l = 0.0048;
m = 0.2607;
n = 19;
LT = zeros(n+1, n+1, n); % Tensor of intensity transition matrices

for i = 1:n
Ls = zeros(i+1,i+1); % Matrix creation for i components
for j = 1:i+1
    for k = 1:i+1
            if k == j
            Ls(j,k) = -((i - j + 1)*m + (j - 1)*l);
            end
            if k == j - 1
                Ls(j,k) = (j - 1)*l;
            end
            if k == j + 1
                 Ls(j,k) = (i - j + 1)*m;
            end
    end
                
end
LT(1:i+1,1:i+1,i) = Ls;

end
%CTMC ergodic prob
J = zeros(n, n);

for a = 1:n
L = LT(1:a+1,1:a+1,a); % Pobranie fragmentu tensora dla systemu z a komponentów
L_transp = L.'; %Transponowanie macierzy
L_transp(a+1,1:a+1) = 1;
    for b = 1:a+1
        if b == a+1
            Z(b,1) = 1;
        else
            Z(b,1) = 0;
        end
    end

J(1,1:a+1) = (L_transp^(-1))*Z;
clear("Z");
EP(a:a,1:a+1) = J(1,1:a+1);
end

Ergodic = EP.';
for j = 1:1:n+1
    for i = 1:1:n
        if j - 2>i
            Ergodic(j,i) = NaN;
        end
    end
end

h = surf(Ergodic);
ylabel('States');
xlabel('Number of components');
zlabel('Ergodic probability');
colorbar;
xticks([0 5 10 15]);
xticklabels([0 5 10 15]);
xlim([1 n]);
yticks([1 6 11 16]);
yticklabels([0 5 10 15]);
ylim([1 n+1]);
fontsize(gcf,12,"pixels");
colormap(jet(200));
shading interp

b = bar3(Ergodic);
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
ylabel('States');
xlabel('Number of components');
zlabel('Ergodic probability');
colorbar;
xticks([0 5 10 15]);
xticklabels([0 5 10 15]);
xlim([0 n+1]);
yticks([1 6 11 16]);
yticklabels([0 5 10 15]);
ylim([0 n+2]);
fontsize(gcf,12,"pixels");
colormap(jet(200));
