function [sS,sD,sD2,lS,lD,lD2,ZVarS,ZVarD,ZVarD2,xx,ZmedioS,ZupS,ZupD,ZupD2,HandleFigD]=rmsDet(AltVarFilt,altinf,Vfin,Vinicio,varsF)

% RMS Segun IEEE TRANSACTIONS ON GEOSCIENCE AND REMOTE SENSING, VOL. 44, NO. 4, APRIL 2006
% Todas las dimensiones se trabajan en mm

% conversion dimensiones fisicas en salida
converso=(1995./(Vfin-Vinicio));    % largo barra medicion 071102 
% converso=(427./(altsup-altinf));    % vertical medicion 071102
% converso=(418./(altsup-altinf));    % vertical de plano 
ZVar(:,1)=(AltVarFilt(:,1)-Vinicio);
ZVar(:,2)=(altinf-AltVarFilt(:,2));

% sin detrend
ZmedioS=(1/varsF)*sum(ZVar(:,2));
ZVarS(:,1)=ZVar(:,1);
ZVarS(:,2)=ZVar(:,2)-ZmedioS;
Z2S=ZVarS(:,2).*ZVarS(:,2);
sS=sqrt((1/(varsF-1))*(sum(Z2S)))*converso;   % puesto que refiero todo a la media
% s=sqrt((1/(varsF-1))*(sum(Z2)-varsF*Zmedio^2))*converso;

% detrend todo el perfil
ZVarD(:,1)=ZVar(:,1);
ZVarD(:,2)=detrend(ZVar(:,2));
Z2D=zeros(varsF,1);
for i=1:varsF
    Z2D(i,1)=ZVarD(i,2)^2;
end
ZmedioD=(1/varsF)*sum(ZVarD(:,2));
sD=sqrt((1/(varsF-1))*(sum(Z2D)-varsF*ZmedioD^2))*converso;

% detrend medio perfil
ZVarD2(:,1)=ZVar(:,1);
ZVarD2(:,2)=detrend(ZVar(:,2),'linear',floor(varsF/2));
Z2D2=zeros(varsF,1);
for i=1:varsF
    Z2D2(i,1)=ZVarD2(i,2)^2;
end
ZmedioD2=(1/varsF)*sum(ZVarD2(:,2));
sD2=sqrt((1/(varsF-1))*(sum(Z2D2)-varsF*ZmedioD2^2))*converso;

% Longitud de correlacion
[lS,xx,ZupS,HandleFigS]=correlato(ZVarS(:,1),ZVarS(:,2),varsF,converso);
[lD2,xx,ZupD2,HandleFigD2]=correlato(ZVarD2(:,1),ZVarD2(:,2),varsF,converso);
[lD,xx,ZupD,HandleFigD]=correlato(ZVarD(:,1),ZVarD(:,2),varsF,converso);
% [lS,xx,ZupS,hachesS,rhoS,rho_splS]=correlato(ZVarS(:,1),ZVarS(:,2),varsF,converso);
% [lD,xx,ZupD,hachesD,rhoD,rho_splD]=correlato(ZVarD(:,1),ZVarD(:,2),varsF,converso);
% [lD2,xx,ZupD2,hachesD2,rhoD2,rho_splD2]=correlato(ZVarD2(:,1),ZVarD2(:,2),varsF,converso);

% % graficacion de rho y aproximaciones
% unosobreE=(1/exp(1))*ones(size(xx,1)-1,1)';
% % cuka=[1:Nmuestreo-1]';
% % figure(4),plot(cuka,rho,'.',cuka,unosobreE,'-b',cuka,rho_spl,'-r');
% HandleFigL=figure(4);
% plot(hachesD,rhoD,'.',hachesD,unosobreE,'-b',hachesD,rho_splD,'-r');
% xlabel('h [mm]');
% ylabel([texlabel('rho'),'(h)']);