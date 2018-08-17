function massExpRot

% Especifica directorio de entrada
directorio = uigetdir('/home/victor/travail/perfi/programa/exp')

% Nombre del archivo de salida
iniciofecha=strfind(directorio,'/0');

NomArch=['res',directorio(iniciofecha+1:iniciofecha+6)];

% Lee directorio y determina numero de archivos
cd(directorio);
archivos=dir(directorio);
Narch1=size(archivos);
Narch=Narch1(1,1);

% si no existen directorios generadas y rotadas los genera
a=0;
d=0;
% sifech=0;
for i=1:Narch
    if archivos(i).isdir==1;
        b=strcmp(archivos(i).name,'generadas');
        c=strcmp(archivos(i).name,'rotadas');
        a=b+a;
        d=c+d;
%     else
%         foto=archivos(i).name;
%         n1=findstr(foto,'JPG');
%         n2=findstr(foto,'jpg');
%         if n1==[]
%             n1=0;
%         end
%         if n2==[]
%             n2=0;
%         end
%         if (n2>=1 || n1>=1)
%             if sifech==0
%                 fecha=datestr(archivos(i).datenum,25);
%                 HoraInicio=datestr(archivos(i).datenum,15);
%                 sifech=1;
%             else
%                 HoraFin=datestr(archivos(i).datenum,15);
%             end
%         end
    end
end
if a==0
    mkdir('generadas');
end
% if d==0
%     mkdir('rotadas');     % genera directorio de imagenes rotadas
% end
fecha='no aun';
HoraInicio='no aun';
HoraFin='no aun';

cd('generadas');

% % Genera archivo de salida tab separated values
archT=fopen([NomArch,'.tsv'],'w');
% fprintf(archT,'"Perfilometro"\t\t\t"Rugosidad"\t"(A)lta\t(M)edia\t(B)aja"\n');
% fprintf(archT,'"Imagenes parcela"\t\t\t"Direccion"\t"(T)ransversal\t(L)ongitudinal"\n');
% fprintf(archT,'"Fecha:"\t%s\t"Inicio:"\t%s\t"Fin:"\t%s\n',fecha,HoraInicio,HoraFin);
% fprintf(archT,'\n');
fprintf(archT,'"Foto"\t"Parcela"\t"Tratamiento"\t"Cuadrante"\t"Direccion"\t"Orientacion"\t"varillas"\t"S (mm)"\t"SD (mm)"\t"SD2 (mm)"\t"L (mm)"\t"LD (mm)"\t"LD2 (mm)"\n');
fclose(archT);

cd(directorio);

 
% Toma imagenes jgp, las procesa completo3 y genera salida
count=0;
for i=1:Narch
    if archivos(i).isdir~=1
        foto=archivos(i).name;
        n1=findstr(foto,'JPG');
        n2=findstr(foto,'jpg');
%         if n1==[]
%             n1=0;
%         end
%         if n2==[]
%             n2=0;
%         end
        if size(n2,1)+size(n1,1)>=1
            foto
            count=count+1;
            [sS,sD,sD2,lS,lD,lD2,altinf,altsup,Vinicio,Vfin,AltVarFilt,varsF]=completoRot(foto,directorio);
            
%             % denominacion parcela
%             if strfind(archivos(i).name,'RB1')
%                 parcela='RB1';
%             elseif strfind(archivos(i).name,'RB2')
%                 parcela='RB2';
%             elseif strfind(archivos(i).name,'RB3')
%                 parcela='RB3';     
%             elseif strfind(archivos(i).name,'RB4')
%                 parcela='RB4';     
%             elseif strfind(archivos(i).name,'RB5')
%                 parcela='RB5';     
%             elseif strfind(archivos(i).name,'RB6')
%                 parcela='RB6';
%                 
%             elseif strfind(archivos(i).name,'RM1')
%                 parcela='RM1';     
%             elseif strfind(archivos(i).name,'RM2')
%                 parcela='RM2';
%             elseif strfind(archivos(i).name,'RM3')
%                 parcela='RM3';
%             elseif strfind(archivos(i).name,'RM4')
%                 parcela='RM4';
%             elseif strfind(archivos(i).name,'RM5')
%                 parcela='RM5';
%             elseif strfind(archivos(i).name,'RM6')
%                 parcela='RM6';
%                 
%             elseif strfind(archivos(i).name,'RA1')
%                 parcela='RA1';     
%             elseif strfind(archivos(i).name,'RA2')
%                 parcela='RA2';
%             elseif strfind(archivos(i).name,'RA3')
%                 parcela='RA3';
%             elseif strfind(archivos(i).name,'RA4')
%                 parcela='RA4';
%             elseif strfind(archivos(i).name,'RA5')
%                 parcela='RA5';
%             elseif strfind(archivos(i).name,'RA6')
%                 parcela='RA6';
%                 
%             elseif strfind(archivos(i).name,'MZ1')
%                 parcela='MZ1';     
%             elseif strfind(archivos(i).name,'MZ2')
%                 parcela='MZ2';
%             elseif strfind(archivos(i).name,'MZ3')
%                 parcela='MZ3';
%             elseif strfind(archivos(i).name,'MZ4')
%                 parcela='MZ4';
%             elseif strfind(archivos(i).name,'MZ5')
%                 parcela='MZ5';
%             elseif strfind(archivos(i).name,'MZ6')
%                 parcela='MZ6';
%                 
%             elseif strfind(archivos(i).name,'TR1')
%                 parcela='TR1';     
%             elseif strfind(archivos(i).name,'TR2')
%                 parcela='TR2';
%             elseif strfind(archivos(i).name,'TR3')
%                 parcela='TR3';
%             elseif strfind(archivos(i).name,'TR4')
%                 parcela='TR4';
%             elseif strfind(archivos(i).name,'TR5')
%                 parcela='TR5';
%             elseif strfind(archivos(i).name,'TR6')
%                 parcela='TR6';                
%                 
%             else
%                 rugosidad='no';
%             end
%             
%             % tipo de tratamiento
%             if strfind(archivos(i).name,'RB')
%                 tratamiento='RB';
%             elseif strfind(archivos(i).name,'RM')
%                 tratamiento='RM';
%             elseif strfind(archivos(i).name,'RA')
%                 tratamiento='RA';
%             elseif strfind(archivos(i).name,'MZ')
%                 tratamiento='MZ';
%             elseif strfind(archivos(i).name,'TR')
%                 tratamiento='TR';
%             else
%                 tratamiento='no';
%             end           

            % cuadrante medicion
            if strfind(archivos(i).name,'L1')
                cuadrante='1';
            elseif strfind(archivos(i).name,'T1')
                cuadrante='1';
                
            elseif strfind(archivos(i).name,'L2')
                cuadrante='2';
            elseif strfind(archivos(i).name,'T2')
                cuadrante='2';
                
            elseif strfind(archivos(i).name,'L3')
                cuadrante='3';
            elseif strfind(archivos(i).name,'T3')
                cuadrante='3';

            elseif strfind(archivos(i).name,'L4')
                cuadrante='4';
            elseif strfind(archivos(i).name,'T4')
                cuadrante='4';
                
            else
                cuadrante='no';
            end            

%             % direccion medicion respecto del laboreo
%             if strfind(archivos(i).name,'L')
%                 direccion='L';
%             elseif strfind(archivos(i).name,'T')
%                 direccion='T';
%             else
%                 direccion='no';
%             end            

            % orientacion geografica medicion
            if strfind(archivos(i).name,'RA1L')
                parcela='RA1';
                tratamiento='RA';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RA1T')
                parcela='RA1';
                tratamiento='RA';
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'RA2L')
                parcela='RA2';
                tratamiento='RA';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RA2T')
                parcela='RA2';
                tratamiento='RA';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'RA3L')
                parcela='RA3';
                tratamiento='RA';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RA3T')
                parcela='RA3';
                tratamiento='RA';                
                direccion='T';
                orientacion='NOSE';                

            elseif strfind(archivos(i).name,'RA4L')
                parcela='RA4';
                tratamiento='RA';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RA4T')
                parcela='RA4';
                tratamiento='RA';                
                direccion='T';
                orientacion='NOSE'; 

            elseif strfind(archivos(i).name,'RA5L')
                parcela='RA5';
                tratamiento='RA';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RA5T')
                parcela='RA5';
                tratamiento='RA';                
                direccion='T';
                orientacion='NOSE'; 
                
            elseif strfind(archivos(i).name,'RA6L')
                parcela='RA6';
                tratamiento='RA';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RA6T')
                parcela='RA6';
                tratamiento='RA';                                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'RM1L')
                parcela='RM1';
                tratamiento='RM';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM1T')
                parcela='RM1';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'RM2L')
                parcela='RM2';
                tratamiento='RM';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM2T')
                parcela='RM2';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';

            elseif strfind(archivos(i).name,'RM3L')
                parcela='RM3';
                tratamiento='RM';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM3T')
                parcela='RM3';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'RM4L')
                parcela='RM4';
                tratamiento='RM';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM4T')
                parcela='RM4';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';
                     
            elseif strfind(archivos(i).name,'RM5L')
                parcela='RM5';
                tratamiento='RM';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM5T')
                parcela='RM5';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';
                            
            elseif strfind(archivos(i).name,'RM5L')
                parcela='RM5';
                tratamiento='RM';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM5T')
                parcela='RM5';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';

            elseif strfind(archivos(i).name,'RM6L')
                parcela='RM6';
                tratamiento='RM';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RM6T')
                parcela='RM6';
                tratamiento='RM';                
                direccion='T';
                orientacion='NOSE';

            elseif strfind(archivos(i).name,'RB1L')
                parcela='RB1';
                tratamiento='RB';
                direccion='L';          % laboreo no discernible
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RB1T')
                parcela='RB1';
                tratamiento='RB';                
                direccion='T';          % laboreo no discernible
                orientacion='NOSE';                

            elseif strfind(archivos(i).name,'RB2L')
                parcela='RB2';
                tratamiento='RB';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RB2T')
                parcela='RB2';
                tratamiento='RB';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'RB3L')
                parcela='RB3';
                tratamiento='RB';                
                direccion='L';          % laboreo no discernible
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RB3T')
                parcela='RB3';
                tratamiento='RB';                
                direccion='T';          % laboreo no discernible
                orientacion='NOSE';

            elseif strfind(archivos(i).name,'RB4L')
                parcela='RB4';
                tratamiento='RB';                
                direccion='L';
                orientacion='NOSE';
            elseif strfind(archivos(i).name,'RB4T')
                parcela='RB4';
                tratamiento='RB';                
                direccion='T';
                orientacion='SONE';                

            elseif strfind(archivos(i).name,'RB5L')
                parcela='RB5';
                tratamiento='RB';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RB5T')
                parcela='RB5';
                tratamiento='RB';                
                direccion='T';
                orientacion='NOSE';                

            elseif strfind(archivos(i).name,'RB6L')
                parcela='RB6';
                tratamiento='RB';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'RB6T')
                parcela='RB6';
                tratamiento='RB';                
                direccion='T';
                orientacion='NOSE';

            elseif strfind(archivos(i).name,'MZ1L')
                parcela='MZ1';
                tratamiento='MZ';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'MZ1T')
                parcela='MZ1';
                tratamiento='MZ';
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'MZ2L')
                parcela='MZ2';
                tratamiento='MZ';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'MZ2T')
                parcela='MZ2';
                tratamiento='MZ';
                direccion='T';
                orientacion='NOSE';                

            elseif strfind(archivos(i).name,'MZ3L')
                parcela='MZ3';
                tratamiento='MZ';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'MZ3T')
                parcela='MZ3';
                tratamiento='MZ';
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'MZ4L')
                parcela='MZ4';
                tratamiento='MZ';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'MZ4T')
                parcela='MZ4';
                tratamiento='MZ';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'MZ5L')
                parcela='MZ5';
                tratamiento='MZ';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'MZ5T')
                parcela='MZ5';
                tratamiento='MZ';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'MZ6L')
                parcela='MZ6';
                tratamiento='MZ';                
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'MZ6T')
                parcela='MZ6';
                tratamiento='MZ';                
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'TR1L')
                parcela='TR1';
                tratamiento='TR';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'TR1T')
                parcela='TR1';
                tratamiento='TR';
                direccion='T';
                orientacion='NOSE';

            elseif strfind(archivos(i).name,'TR2L')
                parcela='TR2';
                tratamiento='TR';
                direccion='L';
                orientacion='NOSE';
            elseif strfind(archivos(i).name,'TR2T')
                parcela='TR2';
                tratamiento='TR';
                direccion='T';
                orientacion='SONE';                

            elseif strfind(archivos(i).name,'TR3L')
                parcela='TR3';
                tratamiento='TR';
                direccion='L';
                orientacion='NOSE';
            elseif strfind(archivos(i).name,'TR3T')
                parcela='TR3';
                tratamiento='TR';
                direccion='T';
                orientacion='SONE';

            elseif strfind(archivos(i).name,'TR4L')
                parcela='TR4';
                tratamiento='TR';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'TR4T')
                parcela='TR4';
                tratamiento='TR';
                direccion='T';
                orientacion='NOSE';
                
            elseif strfind(archivos(i).name,'TR5L')
                parcela='TR5';
                tratamiento='TR';
                direccion='L';
                orientacion='SONE';
            elseif strfind(archivos(i).name,'TR5T')
                parcela='TR5';
                tratamiento='TR';
                direccion='T';
                orientacion='NOSE';                
                
            elseif strfind(archivos(i).name,'TR6L')
                parcela='TR6';
                tratamiento='TR';
                direccion='L';
                orientacion='NOSE';
            elseif strfind(archivos(i).name,'TR6T')
                parcela='TR6';
                tratamiento='TR';
                direccion='T';
                orientacion='SONE';
                
            else
                parcela='no';
                direccion='no';
                orientacion='no';
            end
    
            % salida tsv
            cd('generadas');
            archT=fopen([NomArch,'.tsv'],'w');
            fprintf(archT,'%s\t%s\t%s\t%s\t%s\t%s\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n',foto,parcela,tratamiento,cuadrante,direccion,orientacion,varsF,sS,sD,sD2,lS,lD,lD2);
            fclose(archT);
            cd(directorio);
        end
    end
end