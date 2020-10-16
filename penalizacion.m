clear,close,clc;

k=1:15;
figure;
for n=15:5:100
%n=50;
    FPE=(n+k)./(n-k);
    AIC=2*(k+1)./n;
    AICC=(n+k)./(n-k-2);
    SIC=k*log(n)./n;

    FPE=FPE-FPE(1);
    AIC=AIC-AIC(1);
    AICC=AICC-AICC(1);
    SIC=SIC-SIC(1);

    plot(k,FPE,'-r','LineWidth',2),hold on;
    plot(k,AIC,'-b','LineWidth',2),hold on;
    plot(k,AICC,'-g','LineWidth',2),hold on;
    plot(k,SIC,'-k','LineWidth',2),hold off;
    legend('FPE','AIC','AICC','SIC'),grid;
    axis([1,15,0,1.3])
    title(['n=',num2str(n)])
    pause(1);
end
%AICC selecciona mas grandes.
%Con el tamaño de los datos los criterios tienden a aproximarse.