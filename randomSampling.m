clear,close,clc;

num_points=1000;
x=4*(rand(1,num_points)-0.5);
yok=1.8*tanh(3.2*x+0.8)-2.5*tanh(2.1*x+1.2)-0.2*tanh(0.1*x-0.5); 
RUIDO=0.2 * std(yok);
yruido=RUIDO * randn(size(yok));
y=yok+yruido;

%Definimos numero de puntos. Emplear 100 y 20.
n_sample=20;
n_valid=0.3*n_sample;
n_train=n_sample-n_valid;

% Definimos complejidad máxima
max_complex=15;
% Definimos número de experimentos
n_experiments=1000;
best_model_local=zeros(1, max_complex);

for t=1:n_experiments
    %Definimos x e y.
    clear xsample
    clear ysample
    
    xtrain=4*(rand(1,n_train)-0.5);
    ytrain=1.8*tanh(3.2*xtrain+0.8)-2.5*tanh(2.1*xtrain+1.2)-0.2*tanh(0.1*xtrain-0.5);
    ytrain=ytrain+RUIDO*randn(1,n_train);
        
    xtest=4*(rand(1,n_valid)-0.5);
    ytest=1.8*tanh(3.2*xtest+0.8)-2.5*tanh(2.1*xtest+1.2)-0.2*tanh(0.1*xtest-0.5);
    ytest=ytest+RUIDO*randn(1,n_valid);

    for i=1:max_complex
        p(t,i)={polyfit(xtrain, ytrain,i)};
        yest1=polyval(p{t,i},xtrain);
        yest2=polyval(p{t,i},xtest);
        errorE(t,i)=ecm(yest1-ytrain);
        errorG(t,i)=ecm(yest2-ytest);
    end    
end

errorME=mean(errorE);
errorMG=mean(errorG);

for i=1:max_complex
    lineal_values=[p{:,i}];
    mat_model=reshape(lineal_values',[i + 1, n_experiments])';
    mean_model(i)={mean(mat_model)};
end

xx=1:max_complex;
figure;
plot(xx,errorME,'-r','LineWidth',2),hold on;
plot(xx,errorMG,'-b','LineWidth',2),hold off;
legend('MSEc','MSEv');
xlim([1 max_complex])
ylim([0 1]);
xlabel('Complejidad');
ylabel('MSE');

xmodel=linspace(-2,2,200);
[~,best_model]=min(errorMG); 
h=mean_model{best_model};
ymodel_estimated=polyval(h,xmodel);

figure;
plot(xtrain,ytrain,'xr'),hold on;
plot(xtest,ytest,'.b');
plot(xmodel,ymodel_estimated,'--g','LineWidth',2)
plot(x,yok,'.k'); 
title(['Modelo Seleccionado - Complejidad:',num2str(best_model)])
legend('Datos Entrenamiento','Datos de Test','Función Aproximadora','Función Subyacente');
hold off;

if n_sample==10
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
ylim([-4 3]);
xlabel('Complejidad');
ylabel('MSE');

xx=1:max_complex;
figure;
plot(xx,errorME2,'-r','LineWidth',2),hold on;
plot(xx,errorMG2,'-b','LineWidth',2),hold off;
legend('MSEc','MSEv');
xlim([1 max_complex])
ylim([-4 3]);
xlabel('Complejidad');
ylabel('MSE');