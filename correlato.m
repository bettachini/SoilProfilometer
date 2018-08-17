function [l,xx,Zup,HandleFigL]=correlato(Varx,Vary,varsF,converso)
% function [l,xx,Zup,haches,rho,rho_spl]=correlato(Varx,Vary,varsF,converso)

% Segun IEEE TRANSACTIONS ON GEOSCIENCE AND REMOTE SENSING, VOL. 44, NO. 4, P. 878, APRIL 2006
% Todas las dimensiones se trabajan en mm

% Varx=ZVarS(:,1);
% Vary=ZVarS(:,2);
% Vary=ZVarD(:,2);
% Vary=ZVarD2(:,2);

% distancia media entre puntas varillas (h)
Dxmedia=0;
zi=zeros(varsF-1,1);
for i=1:varsF-1
    Dxmedia=Dxmedia+(Varx(i+1)-Varx(i))/(varsF-1);    %media simple
    zi(i,1)=Varx(i+1)-Varx(i);        % zi vector distancias
end

% h con moda
bajo=min(zi);
alto=max(zi);
segmentos=15;
salto=(alto-bajo)/segmentos;
bordes=bajo:salto:alto;
[q,bin]=histc(zi,bordes);   % histograma de distancias
Dx=(mode(bin)+.5)*salto;     % separacion entre muestreos = mitad de barra histograma
% figure(2),hist(zi,bordes);    ^ visualizar histograma

% perfil: interpolacion c/ splines y smoothing
xx=(floor(min(Varx)):Dx:ceil(max(Varx)))';    % interpolo en saltos de Dx
Nmuestreo=size(xx,1);   % muestreo distancia media varillas
tolerancia_perfil=1/(1+Dx^3/6*1E-1);     % que tanto sigo las varillas individualmente
Zup = csaps(Varx,Vary,tolerancia_perfil,xx);
% plot(Z(:,1),Z(:,3),'.',xx,ys) % con valores en mm
% figure(3),plot(Varx,Vary,'b.',xx,Zup,'r-')  % con valores de pixeles


% estimacion de l: calculo de rho(h) IEEE 44 878 (2006)
% N=Nmuestreo
% \Deltax=h
% z_i=Zup(i)
normalizador=sum(Zup.*Zup);
rho=zeros(Nmuestreo-1,1);
for j=1:Nmuestreo-1     % multiplos de lags h
    rho(j,1)=0;
%     for i=1:Nmuestreo-j
%         rho(j,1)=rho(j,1)+Zup(i,1)*Zup(i+j,1);
    for i=1:Nmuestreo-j+1                       % segun Ulaby p823
        rho(j,1)=rho(j,1)+Zup(i,1)*Zup(i+j-1,1);
    end
    rho(j,1)=rho(j,1)/normalizador;
end

% % no se puede tan facil... hay que hacer un ajuste...
% % el ajuste contemplaria todos los puntos hasta 0
% % usando exp(-(h/l)^n) c/ n y l libres
% OpcAj=fitoptions('Method','NonlinearLeastSquares');
% FunAj=fittype('exp(-(Dx/x)^n)','problem','Dx','options',OpcAj);
% [l,n]=fit(haches,rho,FunAj,'problem',Dx);

% rho(h): interpolacion c/ splines y smoothing
haches=(Dx*converso)*[0:Nmuestreo-2]';
tolerancia_rho=2.8;     % que tanto sigo la autocorrelacion
% Aj_rho = csaps(haches,rho,tolerancia_rho,haches);
[rho_FuncSpl,rho_spl] = spaps(haches,rho,tolerancia_rho);
i=0;
while rho_spl(i+1)>(1/exp(1))
    i=i+1;
end
if i==1          % salwva falla de datos malos
    i=i+1;
end
lspl=converso*Dx*(((i-1)+((exp(-1)-rho_spl(i-1))/(rho_spl(i)-rho_spl(i-1))))-1);

% % l: por interpolacion entre todos los puntos
% i=0;
% while rho(i+1)>(1/exp(1))
%     i=i+1;
% end
% lint=converso*Dx*(((i-1)+((exp(-1)-rho(i-1))/(rho(i)-rho(i-1))))-1);

% Eleccion de l
l=lspl;
% l=lint;

% graficacion de rho y aproximaciones
unosobreE=(1/exp(1))*ones(Nmuestreo-1,1)';
% cuka=[1:Nmuestreo-1]';
% figure(4),plot(cuka,rho,'.',cuka,unosobreE,'-b',cuka,rho_spl,'-r');
HandleFigL=figure('Name','Long correlacion: rho(h)','NumberTitle','off','Visible','off');
% plot(haches,rho,'.',haches,unosobreE,'-b',haches,rho_spl,'-r');

% graficar hasta un apartamiento h=400 mm
i=1;
while haches(i)<300
    i=i+1;
end
haches_graf=haches(1:i);
rho_graf=rho(1:i);
unosobreE_graf=unosobreE(1:i);
rho_spl_graf=rho_spl(1:i);

plot(haches_graf,rho_graf,'.',haches_graf,unosobreE_graf,'-b',haches_graf,rho_spl_graf,'-r');
xlabel('h [mm]');
ylabel([texlabel('rho'),'(h)']);
