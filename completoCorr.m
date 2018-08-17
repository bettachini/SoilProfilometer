function [sS,sD,sD2,lS,lD,lD2,altinf,altsup,Vinicio,Vfin,AltVarFilt,varsF,valida]=completoCorr(foto,directorio)
     
img=imread(foto);

% Rotacion imagen
imgrot2=rotomaticExp(img);
            
% Vinicio y Vfin experimental p/ colores barra amarilla roja
[altinf,altsup,Vinicio,Vfin,HSV]=HorRMax(imgrot2);

% recorte area varillas
guardaHsup=floor(.1*(altinf-altsup)); % pixeles desde borde superior
guardaHinf=floor(.13*(altinf-altsup)); % pixeles desde borde inferior
guardaVocc=floor(.008*(Vfin-Vinicio)); % pixeles desde borde izquierdo
guardaVori=floor(.008*(Vfin-Vinicio)); % pixeles desde borde derecho
rect=[Vinicio+guardaVocc altsup+guardaHsup (Vfin-Vinicio-guardaVocc-guardaVori) (altinf-altsup-guardaHsup-guardaHinf)];
AreaVar=imcrop(imgrot2,rect);

% Generar imagenes blanco y negro para filtros
bwAreaVar=imadjust(rgb2gray(AreaVar));

% Generar imagen filtrada realce horizontal para Vinicio, Vfin
Hprewitt=edge(bwAreaVar,'prewitt',.13,'horizontal');

% Alturas varillas
[AltVar,vars]=varillasExp3(Hprewitt,Vinicio+guardaVocc,Vfin-guardaVori,altinf-guardaHinf,altsup+guardaHsup);

% Filtra varillas incorrectas
[AltVarFilt,varsF]=filtroVars(AltVar,vars,bwAreaVar,altsup,Vinicio,guardaHsup,guardaVocc,altinf,Vfin,guardaHinf,guardaVori);

% graficacion de prueba varillas
leyenda=['Imagen: ',foto,];
handTEST=figure('Name',leyenda,'NumberTitle','off');
imshow(imgrot2);   % muestra imagen rotada
hold on;
bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
plot(AltVarFilt(:,1),AltVarFilt(:,2),'r.');     % solo bordes y puntos a procesar para mejorar legibilidad

% correccion manual
valida=1;
while valida==1
    valida=menu('Que hacer?','Procesar foto','Descartar foto', 'Eliminar punto', 'Agregar punto');
	switch valida
        case 1  % procesar
            seguir=menu('Proceder con el procesamiento de la foto?','Si','Cancelar');
            if seguir==1
                valida=2;
                break;  % sale del loop y pasa al procesamiento
            end
        case 2 % descartar foto
            descarte=menu('Seguro que desea descartar la foto?','Descartar','No!');
            if descarte==1
                valida=5;
            else
                valida=1;
            end
        case 3 % eliminar punto
            HandCursor = datacursormode(handTEST);
            seguir=menu('Seleccione el punto','Eliminar','Cancelar');
            if seguir==1
                cursor = getCursorInfo(HandCursor);
                if size(cursor,1)~=0 % si hay punto seleccionado
                    for i=1:varsF
                        if AltVarFilt(i,1)==cursor.Position(1); % coordenada x del punto
                            AltVarFilt(i,:)=[];
                            varsF=varsF-1;
                            ZoomActual=axis; % conserva el dato de zoom
                            close(handTEST);
                            break % corta el for que busca la varilla
                        end
                    end
                    handTEST=figure('Name',leyenda,'NumberTitle','off');
                    imshow(imgrot2);   % muestra imagen rotada
                    axis(ZoomActual); % aplica el zoom anterior
                    hold on;
                    bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
                    plot(AltVarFilt(:,1),AltVarFilt(:,2),'r.');     % solo bordes y puntos a procesar para mejorar legibilidad
                else
                    errordlg('Mal centrado: no deben figurar valores de RGB en el cuadro');
                end               
            end
            valida=1;
        case 4 % agregar punto
            HandCursor = datacursormode(handTEST);
            seguir=menu('Ubique el cursor','Agregar','Cancelar');
            if seguir==1
                cursor = getCursorInfo(HandCursor);
                if size(cursor,1)~=0 % verificar que se haya seleccionado una posicion valida
                    for i=1:varsF
                        if AltVarFilt(i,1)==cursor.Position(1); % coordenada x del punto
                            existe=1;
                        else
                            existe=0;
                        end
                    end
                    if existe==1
                        errordlg('El punto ya existe');
                    else
                        ZoomActual=axis; % conserva el dato de zoom
                        close(handTEST);
                        AltVarFilt2=zeros(varsF+1,2);
                        j=1;
                        while AltVarFilt(j,1)<cursor.Position(1)
                            j=j+1;
                        end
                        for k=1:j-1
                            AltVarFilt2(k,:)=AltVarFilt(k,:);
                        end
                        AltVarFilt2(j,1)=cursor.Position(1);
                        AltVarFilt2(j,2)=cursor.Position(2);
                        for k=j+1:varsF+1
                            AltVarFilt2(k,:)=AltVarFilt(k-1,:);
                        end
                        AltVarFilt=AltVarFilt2;
                        varsF=varsF+1;
                        handTEST=figure('Name',leyenda,'NumberTitle','off');
                        imshow(imgrot2);   % muestra imagen rotada
                        axis(ZoomActual); % aplica el zoom anterior
                        hold on;
                        bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
                        plot(AltVarFilt(:,1),AltVarFilt(:,2),'r.');     % solo bordes y puntos a procesar para mejorar legibilidad
                    end
                end
            end
            valida=1;
	end
end
close(handTEST);

% Calcula todo DEUXIEME FOIS
[sS,sD,sD2,lS,lD,lD2,ZVarS,ZVarD,ZVarD2,xx,ZmedioS,ZupS,ZupD,ZupD2,HandleFigD]=rmsDet(AltVarFilt,altinf,Vfin,Vinicio,varsF);

% graba imagen con bordes y puntos detectados
handPerfil=figure('Name','Perfil','NumberTitle','off','Visible','off');
imshow(imgrot2);   % muestra imagen rotada
% imshow(imgrot2,'Border','tight');   % version 2007 solamente
bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
hold on;
plot(AltVarFilt(:,1),AltVarFilt(:,2),'r.');     % varillas: verde, FiltAlt (corregidos) en rojo
plot(Vinicio+xx,altinf-(ZmedioS+ZupS),'y');

% establece parametros de grabacion (directorio, etc.)
cd generadas;
[pathstr, filename, ext, versn] = fileparts(foto);

% graba los datos de alturas
Z=[ZVarS ZVarD(:,2) ZVarD2(:,2)];
save(['alt',filename,'.dat'],'Z','-ASCII');
salfilename= ['sal',filename,'.jpg'];

% graba imagen de perfil detectado
saveas(handPerfil,salfilename,'jpg');  % graba perfil c/ puntos y borde
close(handPerfil);

% graba grafica de funcion de autocorrelacion
lfile=['L',filename,'.jpg'];
saveas(HandleFigD,lfile,'jpg');  % graba perfil c/ puntos y borde
close(HandleFigD);

cd(directorio);