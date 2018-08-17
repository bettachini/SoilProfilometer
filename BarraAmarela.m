function [supi,sizeSupi,HSV,filas,columnas,colores]=BarraAmarela(imgAdj)

% entrega puntos del borde superior de la barra amarilla y su ancho alli

% determina escala (ver si se le pasa como argumento a la funcion)
format long;
[filas columnas colores]=size(imgAdj);

% Descriptores HSV barra amarilla
Hmin=0.11;
% Hmin=0.13;
Hmax=0.18;
Smin=0.6; % este anduvo
% Smin=0.35; % este es prueba

% Vmin=.5;
% Vmax=0.7;

% pasa a HSV
HSV=rgb2hsv(imgAdj);

% busca altinf como borde superior de barra amarilla y los carga en vector
cuarto=floor(columnas/4);
divisiones=50;
pasocol=floor(2*cuarto/divisiones);
i=0;
altinf=0;
k=0;
for i=cuarto:pasocol:cuarto*3
    j=floor(0.32*filas);
    jauneVieux=0;

    % cuenta pixeles amarillos continuos
    while j<.7*filas
        if (HSV(j,i,1)>=Hmin && HSV(j,i,1)<=Hmax && HSV(j,i,2)>=Smin) % si es amarillo
            jaune=0;
            up=j;
            while (HSV(j,i,1)>=Hmin && HSV(j,i,1)<=Hmax && HSV(j,i,2)>=Smin)
                jaune=jaune+1;
                j=j+1;
            end
            if jaune>jauneVieux
                borde=up;
                jauneVieux=jaune;
            end
        end
        j=j+1; % contador vertical j
    end
    
    k=k+1; % numero de puntos registrados en barra
    sup(k,1)=i; % registra x sup barra
    sup(k,2)=borde; % registra altura sup barra
	sup(k,3)=jaune; % ancho barra
end

% eliminar outliers
med=mean(sup(:,2));
unadesv=std(sup(:,2));
sizeSupi=0;
for i=1:k
    if abs(sup(i,2)-med)<unadesv % en supi puntos a ajustar
        sizeSupi=sizeSupi+1;
        supi(sizeSupi,1)=sup(i,1);
        supi(sizeSupi,2)=sup(i,2);
        supi(sizeSupi,3)=sup(i,3);
    end
end

% % graficacion de prueba
% imshow(imgAdj);
% hold on;
% plot(supi(:,1),supi(:,2),'*');