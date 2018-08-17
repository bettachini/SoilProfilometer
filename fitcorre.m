function lajuste=fitcorre(zz,Dx,converso)

corte=floor((1000/(converso*Dx)));
haches2=[1:corte]';
zz2(1:corte,1)=zz(1:corte,1);
% 
% 
OpcAj=fitoptions('Method','NonlinearLeastSquares');
% FunAj=fittype('exp(-(x/l)^n)','problem','Dx','options',OpcAj); % c/ potencia libre
% FunAj=fittype('exp(-(x/l2)^2)','options',OpcAj); % gaussiana
FunAj=fittype('exp(-(x/l2)^2)','options',OpcAj); % exponencial
q=fit(haches2,zz2,FunAj);
figure(10),plot(q);
hold on;
plot(haches2,zz2,'.');

lajuste=q.l2*Dx*converso;

% x0=0;
% y0=1;
% 
% l = fmincon(@(X)objfun(X,haches2,zz2),12,[],[],x0,y0)
% plot(x,y,'.b-') % Plot original
% hold on
% plot(x0,y0,'gx','linewidth',4) % Plot point to go through yact = C(1)*x.^3+C(2)*x.^2+C(3)*x+C(4);
% plot(x,yact,'r','linewidth',2) % Plot fitted data
