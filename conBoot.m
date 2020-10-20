close,clear,clc;

%Definimos numero de puntos. Emplear 100 y 20.
n_sample=50;
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
        yest=polyval(p{i,t},xtest);
        errorG(i,t)=ecm(yest-ytest);
    end
end

errorMG=mean(errorG);

xx=1:max_complex;
figure;
plot(xx,log(errorMG),'-g','LineWidth',2),hold on;

%Usamos AICC y AIC.
n=20;
k=1:15;
%AIC.
errorMG1=log(errorMG)+(2*(k+1))/n;
errorMG2=log(errorMG)+(n+k)/(n-k-2);

xx=1:max_complex;
plot(xx,errorMG1,'-r','LineWidth',2),hold on;

xx=1:max_complex;
plot(xx,errorMG2,'-b','LineWidth',2),hold off;
legend('Bootstrap','AIC','AICC');
xlim([1 max_complex])
xlabel('Complejidad');
ylabel('log(MSE)');

