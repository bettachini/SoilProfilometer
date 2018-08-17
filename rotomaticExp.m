function imgrot2=rotomaticExp(img)

% 1) limite superior barra amarilla ubicada en HSV
% 2) eliminacion outliers limite superior
% 3) ajuste pendiente a estos puntos
% 4) rotacion y exportacion imagen


% ecualiza la imagen en RGB
imgAdj=imadjust(img,stretchlim(img));

% Barra amarela
[supi,sizeSupi,HSV,filas,columnas,colores]=BarraAmarela(imgAdj);

% rotar con pendiente de ajuste a supi
p=polyfit(supi(:,1),supi(:,2),1);
Ang=(180/pi)*atan(p(1));
%if abs(Ang)>0.1;
imgrot=imrotate(imgAdj,Ang,'bilinear');

    
% recorte de imagen
reborde=3; % pixels a "comerse"
Bizq=3; % borde izquierdo
Barr=3; % borde arriba
[Baba Bder]=size(imgrot);
Bder=columnas; % borde derecho
Baba=filas; % borde abajo
if p(1)>0
    while imgrot(filas-reborde,Bizq,1)==0 % borde izquierdo abajo
        Bizq=Bizq+1;
    end
    while imgrot(reborde,Bder,1)==0 % borde derecho arriba
        Bder=Bder-1;
    end
    while imgrot(Barr,reborde,1)==0 % borde arriba izquierdo
        Barr=Barr+1;
    end
    while imgrot(Baba,columnas-reborde,1)==0 % borde abajo derecho
        Baba=Baba-1;
    end
else
    while imgrot(reborde,Bizq,1)==0 % borde izquierdo arriba
        Bizq=Bizq+1;
    end
    while imgrot(filas-reborde,Bder,1)==0 % borde derecho abajo
        Bder=Bder-1;
    end
    while imgrot(Barr,columnas-reborde,1)==0 % borde arriba izquierdo
        Barr=Barr+1;
    end
    while imgrot(Baba,reborde,1)==0 % borde abajo derecho
        Baba=Baba-1;
    end
end
rect=[Bizq Barr (Bder-Bizq) (Baba-Barr)];
imgrot2=imcrop(imgrot,rect);