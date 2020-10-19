close,clear,clc;

%Definimos numero de puntos. Emplear 100 y 20.
n_sample=20;
n_valid=0.3*n_sample;
n_train=n_sample-n_valid;

% Definimos complejidad máxima
max_complex=15;
% Definimos número de experimentos
n_experiments=1000;
best_model_local=zeros(1, max_complex);

for t=1:max_complex
    %Definimos x e y.
    
    x=4*(rand(1,n_sample)-0.5);
    y=1.8*tanh(3.2*x+0.8)-2.5*tanh(2.1*x+1.2)-0.2*tanh(0.1*x-0.5);
    yok=1.8*tanh(3.2*x+0.8)-2.5*tanh(2.1*x+1.2)-0.2*tanh(0.1*x-0.5); 
    RUIDO=0.2*std(yok);
    y=RUIDO*randn(size(yok));
    
    for i=1:250
        ind=bootdata(x,1);
        xtrain=x(ind);
        ytrain=y(ind);
        xtest=x;
        ytest=y;
        p(i,t)={polyfit(xtrain,ytrain,t)};
        yest1=polyval(p{i,t},xtrain);
        yest2=polyval(p{i,t},xtest);
        errorE(i,t)=ecm(yest1-ytrain);
        errorG(i,t)=ecm(yest2-ytest);
    end
end

errorME=mean(errorE);
errorMG=mean(errorG);

xx=1:max_complex;
figure;
plot(xx,errorME,'-r','LineWidth',2),hold on;
plot(xx,errorMG,'-b','LineWidth',2),hold off;
legend('MSEc','MSEv');
xlim([1 max_complex])
ylim([0 0.5]);
xlabel('Complejidad');
ylabel('MSE');

if n_sample==100
    %Usamos SIC y AIC.
    n=100;
    k=1:15;
    %AIC.
    errorMG1=log(errorMG)+(2*(k+1))/n;
    errorME1=log(errorME)+(2*(k+1))/n;  
    %SIC.
    errorMG2=log(errorMG)+(k*log(n)/n);
    errorME2=log(errorME)+(k*log(n)/n);
end

if n_sample==20
    %Usamos AICC y AIC.
    n=20;
    k=1:15;
    %AIC.
    errorMG1=log(errorMG)+(2*(k+1))/n;
    errorME1=log(errorME)+(2*(k+1))/n;
    errorMG2=log(errorMG)+(n+k)/(n-k-2);
    errorME2=log(errorME)+(n+k)/(n-k-2);
end

xx=1:max_complex;
figure;
plot(xx,errorME1,'-r','LineWidth',2),hold on;
plot(xx,errorMG1,'-b','LineWidth',2),hold off;
legend('MSEc','MSEv');
xlim([1 max_complex])
xlabel('Complejidad');
ylabel('MSE');

xx=1:max_complex;
figure;
plot(xx,errorME2,'-r','LineWidth',2),hold on;
plot(xx,errorMG2,'-b','LineWidth',2),hold off;
legend('MSEc','MSEv');
xlim([1 max_complex])
xlabel('Complejidad');
ylabel('MSE');