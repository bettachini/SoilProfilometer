function [sS,sD,sD2,lS,lD,lD2,altinf,altsup,Vinicio,Vfin,AltVarFilt,varsF]=completoRot(foto,directorio)

img=imread(foto);

% Rotacion imagen
imgrot2=rotomaticExp(img);

% % graba rotada
% rotfilename= ['rot',foto];
% cd rotadas;
% imwrite(imgrot2,rotfilename);
% cd(directorio);
            
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

% Calcula todo
[sS,sD,sD2,lS,lD,lD2,ZVarS,ZVarD,ZVarD2,xx,ZmedioS,ZupS,ZupD,ZupD2,HandleFigD]=rmsDet(AltVarFilt,altinf,Vfin,Vinicio,varsF);

% % graficacion de prueba varillas
% handTEST=figure('Name','la que lo remil recontra...','NumberTitle','off')
% imshow(imgrot2,'Border','tight');   % muestra imagen rotada
% bordes(Vinicio,Vfin,altsup,altinf); % limites del area en verde
% hold on;
% plot(AltVar(:,1),AltVar(:,2),'g.');
% plot(AltVarFilt(:,1),AltVarFilt(:,2),'r.');
% plot(Vinicio+xx,altinf-(ZmedioS+ZupS),'y');

% muestra y graba imagen con bordes y puntos detectados
handPerfil=figure('Name','Perfil','NumberTitle','off','Visible','off');
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
close(handPerfil);

% graba grafica de funcion de autocorrelacion
lfile=['L',filename,'.jpg'];
saveas(HandleFigD,lfile,'jpg');  % graba perfil c/ puntos y borde
close(HandleFigD);

cd(directorio);