function [AltVarFilt,varsF]=filtroVars(AltVar,vars,bwAreaVar,altsup,Vinicio,guardaHsup,guardaVocc,altinf,Vfin,guardaHinf,guardaVori)
% function [AltVarFilt,varsF]=filtroVars(AltVar,vars,bwAreaVar,altsup,Vinicio)

% puntos AltVar (X) -> AltVarFilt si
% # pixeles blancos en b(20) >15 
% # pixeles negros en n(28) >2 

% 6    -bbbbb-
% 5    -bbbbb-
% 4    -bbbbb-
% 3    -bbbbb-
% 2    -------
% 1    ------- 
% c    ---X---
% 1    -------    
% 2    nnnnnnn
% 3    nnnnnnn
% 4    nnnnnnn
% 5    nnnnnnn
% 6    nnnnnnn
% 7    nnnnnnn
% 8    nnnnnnn
% 9    nnnnnnn
% 10   nnnnnnn
% 11   nnnnnnn
% 12   nnnnnnn
% 13   nnnnnnn

varsF=0;
for k=1:vars
    xcent=AltVar(k,1);              % coord x central
    ycent=round(AltVar(k,2));       % coord y cenral
    BlancosSup=0;
    NegrosInf=0;
    for i=xcent-2:xcent+2
        for j=ycent-6:ycent-3 % unos 12 pixels
            if j-altsup-guardaHsup<=0 || i-Vinicio-guardaVocc<=0 || j-altsup-guardaHsup>altinf-altsup-guardaHsup-guardaHinf || i-Vinicio-guardaVocc>Vfin-Vinicio-guardaVocc-guardaVori
                BlancosSup=BlancosSup+1;
            else
                if bwAreaVar(j-altsup-guardaHsup,i-Vinicio-guardaVocc)>100
%                 if bwAreaVar(j-altsup,i-Vinicio)>100
                    BlancosSup=BlancosSup+1;
                end
            end
        end
    end
	for i=xcent-3:xcent+3
        for j=ycent+6:ycent+13 % unos 15 pixels
            if j-altsup-guardaHsup<=0 || i-Vinicio-guardaVocc<=0 || j-altsup-guardaHsup>altinf-altsup-guardaHsup-guardaHinf || i-Vinicio-guardaVocc>Vfin-Vinicio-guardaVocc-guardaVori
                NegrosInf=NegrosInf+1;
            else
                if bwAreaVar(j-altsup-guardaHsup,i-Vinicio-guardaVocc)<70
%                 if bwAreaVar(j-altsup,i-Vinicio)<70
                    NegrosInf=NegrosInf+1;
                end
            end
        end
	end
    if BlancosSup>7 && NegrosInf>=8
%     if BlancosSup>15 && NegrosInf>=2        
        varsF=varsF+1;
        AltVarFilt(varsF,:)=AltVar(k,:);
    end
end
