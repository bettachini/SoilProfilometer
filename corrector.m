function corrector

% seleccion GUI foto a reprocesar
[foto,ordDir] = uigetfile('*.jpg;*.JPG');
cd(ordDir);        
img=imread(foto);

% Rotacion imagen
imgrot2=rotomaticExp(img);
            
% Vinicio y Vfin experimental p/ colores barra amarilla roja
[altinf,altsup,Vinicio,Vfin,HSV]=HorRMax(imgrot2);

% recorte area varillas
guardaHsup=floor(.1*(altinf-altsup)); % pixeles desde bordes superior
guardaHinf=floor(.13*(altinf-altsup)); % pixeles desde bordes superior
guardaVocc=floor(.008*(Vfin-Vinicio)); % pixeles desde bordes izquierdo
guardaVori=floor(.008*(Vfin-Vinicio)); % pixeles desde bordes derecho
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
handTEST=figure('Name','Indicar puntos a eliminar','NumberTitle','off');
imshow(imgrot2,'Border','tight');   % muestra imagen rotada
hold on;
bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
plot(AltVarFilt(:,1),AltVarFilt(:,2),'r.');     % solo bordes y puntos a procesar para mejorar legibilidad
HandCursor = datacursormode(handTEST);

% correccion manual
respuesta=1;
seguir=0;
while respuesta==1
    seguir=menu('Borrar este punto?','Ok');
    if seguir==1
        cursor = getCursorInfo(HandCursor);
        if size(cursor,1)==0                        % interrumpe si no se selecciona punto
            break
        end        
        for i=1:varsF
            if AltVarFilt(i,1)==cursor.Position(1); % coordenada x del punto
                AltVarFilt(i,:)=[];
                varsF=varsF-1;
                break
            end
        end
    end
    seguir=0;
	respuesta=menu('Restan puntos a borrar?','Si','No');
end
close(handTEST);

% Calcula todo DEUXIEME FOIS
[sS,sD,sD2,lS,lD,lD2,ZVarS,ZVarD,ZVarD2,xx,ZmedioS,ZupS,ZupD,ZupD2,HandleFigD]=rmsDet(AltVarFilt,altinf,Vfin,Vinicio,varsF);

% graba imagen con bordes y puntos detectados
handPerfil=figure('Name','Imagen procesada','NumberTitle','off');
imshow(imgrot2,'Border','tight');   % muestra imagen rotada
bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
hold on;
plot(AltVar(:,1),AltVar(:,2),'g.',AltVarFilt(:,1),AltVarFilt(:,2),'r.');     % varillas: verde, FiltAlt (corregidos) en rojo
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
% close(handPerfil);

% graba grafica de funcion de autocorrelacion
lfile=['L',filename,'.jpg'];
saveas(HandleFigD,lfile,'jpg');  % graba perfil c/ puntos y borde
close(HandleFigD);

% archivo con datos corregidos

% cuadrante medicion
if strfind(filename,'L1')
    cuadrante='1';
elseif strfind(filename,'T1')
    cuadrante='1';

elseif strfind(filename,'L2')
    cuadrante='2';
elseif strfind(filename,'T2')
    cuadrante='2';

elseif strfind(filename,'L3')
    cuadrante='3';
elseif strfind(filename,'T3')
    cuadrante='3';

elseif strfind(filename,'L4')
    cuadrante='4';
elseif strfind(filename,'T4')
    cuadrante='4';

else
    cuadrante='no';
end 

% orientacion geografica medicion
if strfind(filename,'RA1L')
    parcela='RA1';
    tratamiento='RA';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RA1T')
    parcela='RA1';
    tratamiento='RA';
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RA2L')
    parcela='RA2';
    tratamiento='RA';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RA2T')
    parcela='RA2';
    tratamiento='RA';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RA3L')
    parcela='RA3';
    tratamiento='RA';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RA3T')
    parcela='RA3';
    tratamiento='RA';                
    direccion='T';
    orientacion='NOSE';                

elseif strfind(filename,'RA4L')
    parcela='RA4';
    tratamiento='RA';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RA4T')
    parcela='RA4';
    tratamiento='RA';                
    direccion='T';
    orientacion='NOSE'; 

elseif strfind(filename,'RA5L')
    parcela='RA5';
    tratamiento='RA';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RA5T')
    parcela='RA5';
    tratamiento='RA';                
    direccion='T';
    orientacion='NOSE'; 

elseif strfind(filename,'RA6L')
    parcela='RA6';
    tratamiento='RA';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RA6T')
    parcela='RA6';
    tratamiento='RA';                                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM1L')
    parcela='RM1';
    tratamiento='RM';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM1T')
    parcela='RM1';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM2L')
    parcela='RM2';
    tratamiento='RM';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM2T')
    parcela='RM2';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM3L')
    parcela='RM3';
    tratamiento='RM';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM3T')
    parcela='RM3';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM4L')
    parcela='RM4';
    tratamiento='RM';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM4T')
    parcela='RM4';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM5L')
    parcela='RM5';
    tratamiento='RM';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM5T')
    parcela='RM5';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM5L')
    parcela='RM5';
    tratamiento='RM';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM5T')
    parcela='RM5';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RM6L')
    parcela='RM6';
    tratamiento='RM';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RM6T')
    parcela='RM6';
    tratamiento='RM';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RB1L')
    parcela='RB1';
    tratamiento='RB';
    direccion='L';          % laboreo no discernible
    orientacion='SONE';
elseif strfind(filename,'RB1T')
    parcela='RB1';
    tratamiento='RB';                
    direccion='T';          % laboreo no discernible
    orientacion='NOSE';                

elseif strfind(filename,'RB2L')
    parcela='RB2';
    tratamiento='RB';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RB2T')
    parcela='RB2';
    tratamiento='RB';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'RB3L')
    parcela='RB3';
    tratamiento='RB';                
    direccion='L';          % laboreo no discernible
    orientacion='SONE';
elseif strfind(filename,'RB3T')
    parcela='RB3';
    tratamiento='RB';                
    direccion='T';          % laboreo no discernible
    orientacion='NOSE';

elseif strfind(filename,'RB4L')
    parcela='RB4';
    tratamiento='RB';                
    direccion='L';
    orientacion='NOSE';
elseif strfind(filename,'RB4T')
    parcela='RB4';
    tratamiento='RB';                
    direccion='T';
    orientacion='SONE';                

elseif strfind(filename,'RB5L')
    parcela='RB5';
    tratamiento='RB';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RB5T')
    parcela='RB5';
    tratamiento='RB';                
    direccion='T';
    orientacion='NOSE';                

elseif strfind(filename,'RB6L')
    parcela='RB6';
    tratamiento='RB';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'RB6T')
    parcela='RB6';
    tratamiento='RB';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'MZ1L')
    parcela='MZ1';
    tratamiento='MZ';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'MZ1T')
    parcela='MZ1';
    tratamiento='MZ';
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'MZ2L')
    parcela='MZ2';
    tratamiento='MZ';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'MZ2T')
    parcela='MZ2';
    tratamiento='MZ';
    direccion='T';
    orientacion='NOSE';                

elseif strfind(filename,'MZ3L')
    parcela='MZ3';
    tratamiento='MZ';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'MZ3T')
    parcela='MZ3';
    tratamiento='MZ';
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'MZ4L')
    parcela='MZ4';
    tratamiento='MZ';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'MZ4T')
    parcela='MZ4';
    tratamiento='MZ';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'MZ5L')
    parcela='MZ5';
    tratamiento='MZ';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'MZ5T')
    parcela='MZ5';
    tratamiento='MZ';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'MZ6L')
    parcela='MZ6';
    tratamiento='MZ';                
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'MZ6T')
    parcela='MZ6';
    tratamiento='MZ';                
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'TR1L')
    parcela='TR1';
    tratamiento='TR';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'TR1T')
    parcela='TR1';
    tratamiento='TR';
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'TR2L')
    parcela='TR2';
    tratamiento='TR';
    direccion='L';
    orientacion='NOSE';
elseif strfind(filename,'TR2T')
    parcela='TR2';
    tratamiento='TR';
    direccion='T';
    orientacion='SONE';                

elseif strfind(filename,'TR3L')
    parcela='TR3';
    tratamiento='TR';
    direccion='L';
    orientacion='NOSE';
elseif strfind(filename,'TR3T')
    parcela='TR3';
    tratamiento='TR';
    direccion='T';
    orientacion='SONE';

elseif strfind(filename,'TR4L')
    parcela='TR4';
    tratamiento='TR';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'TR4T')
    parcela='TR4';
    tratamiento='TR';
    direccion='T';
    orientacion='NOSE';

elseif strfind(filename,'TR5L')
    parcela='TR5';
    tratamiento='TR';
    direccion='L';
    orientacion='SONE';
elseif strfind(filename,'TR5T')
    parcela='TR5';
    tratamiento='TR';
    direccion='T';
    orientacion='NOSE';                

elseif strfind(filename,'TR6L')
    parcela='TR6';
    tratamiento='TR';
    direccion='L';
    orientacion='NOSE';
elseif strfind(filename,'TR6T')
    parcela='TR6';
    tratamiento='TR';
    direccion='T';
    orientacion='SONE';

else
    parcela='no';
    direccion='no';
    orientacion='no';
end

archT=fopen([filename,'.tsv'],'a');
fprintf(archT,'%s\t%s\t%s\t%s\t%s\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',foto,parcela,tratamiento,cuadrante,direccion,orientacion,varsF,sS,sD,sD2,lS,lD,lD2);
fclose(archT);

cd(ordDir);