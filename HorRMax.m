function [altinf,altsup,Vinicio,Vfin,HSV]=HorRMax(imgrot2)

% Barra Amarela
[supi,sizeSupi,HSV,filas,columnas,colores]=BarraAmarela(imgrot2);

% Determinacion altura y ancho de la barra
altinf=round(mean(supi(:,2))); % media de alt sup barra


% Aca empieza el analisis por HSV bordes laterales

% Viendo por maximo 
AnchoBarra=max(supi(:,3));    % Esto falla terriblemente, porque?
guarda=ceil(.2*AnchoBarra);

% % tomando una media
% AnchoBarra=round(mean(supi(:,3))); % algunos se truncan rapido
% guarda=???

% % el camino tradicional
% AnchoBarra=15; % altura en pixels barra amarilla
% guarda=9;


% recorte de area de interes
rect=[1 altinf+guarda columnas AnchoBarra-guarda];
HSVimgR=imcrop(HSV,rect);

% imgR=imcrop(imgAdj,rect);
% HSVimgR=rgb2hsv(imgR);

% descriptores HSV de cuadrados rojos
HminR=.05;
HmaxR=.85;
SminR=12;

Vfin=0;
Vinicio=0;
bajamos=AnchoBarra-2*guarda;
for j=1:bajamos
    i=floor(columnas/2);
    while i<columnas && ~(HSVimgR(j,i,1)<=HminR || HSVimgR(j,i,1)>=HmaxR) % excluye rojo
%    while i<columnas && ~((HSV(j,i,1)<=HminR || HSV(j,i,1)>=HmaxR) && HSV(j,i,2)>=SminR) % excluye rojo
        i=i+1; % registra borde interno de marca roja der
    end
    Vfin=Vfin+(i/(bajamos));
    i=floor(columnas/2);
    while i>1 && ~(HSVimgR(j,i,1)<=HminR || HSVimgR(j,i,1)>=HmaxR) % excluye rojo
        i=i-1; % registra borde interno de marca roja izq
    end
    Vinicio=Vinicio+(i/(bajamos));
end
Vfin=floor(Vfin);
Vinicio=floor(Vinicio);



% Alsup estimada
altsup = floor(altinf - (Vfin - Vinicio)*(427./1995.));
