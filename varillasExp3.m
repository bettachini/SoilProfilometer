function [AltVar,vars]=varillasExp3(matpunt,Vinicio,Vfin,altinf,altsup)
% Entrega las coordenadas de las varillas en pixels

weiss=0;
count=0;
mox=0;
moy=0;
dernierx=Vinicio;
% guardaH=1;
% guardaHs=1;
% guardaV=1;

vars=0;
for i=1:(Vfin-Vinicio) % barre columnas de izq a der % cambio aca
    for j=1:(altinf-altsup) % barre desde arriba hacia abajo % cambio aca
% for i=guardaV:(Vfin-Vinicio)-guardaV % barre columnas de izq a der % cambio aca
%     for j=guardaHs:(altinf-altsup)-guardaH % barre desde arriba hacia abajo % cambio aca
        if matpunt(j,i)==1 % si pixel matpunt es blanco
            weiss=1; % condicion de no suma 
            count=count+1; % sumador de pixels blancos 
            moy=moy+j; % sumador coordenadas y
            mox=mox+i; % sumador coordenadas x
        end
    end
    if weiss==0;
        if count~=0 && i~=dernierx % si se corta racha blanca
            q=mod((i-dernierx),3); % busca ancho blanco >= 3 pixels
            moy=moy/count; % centroide vertical borde varilla
            if q>1
                paso=(i-dernierx)/q; % cuantos anchos de 3 pixels
                for p=1:q
                    mox=floor(paso*p+dernierx); % centroide: inicio+anchos
                end
            else
                mox=floor(mox/count); % centroide: inicio+ancho
            end
        vars=vars+1;
        AltVar(vars,1)=mox+Vinicio; % cambio aca
%         AltVar(vars,2)=moy+altsup; % cambio aca
        AltVar(vars,2)=moy+altsup; % cambio aca
        mox=0;
        moy=0;
        count=0;
        dernierx=i; % marca la ultima x en que habia blanco
        end
    end
%        q=mod(,3);
%        if q>=2;
%           for n=1:q
%           end
%        end
%        count=0;
    weiss=0;
end