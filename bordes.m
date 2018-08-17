function bordes(Vinicio,Vfin,altsup,altinf)

hsupx=[Vinicio:Vfin];
hsupy=altsup*ones(1,1+Vfin-Vinicio);

hinfx=[Vinicio:Vfin];
hinfy=altinf*ones(1,1+Vfin-Vinicio);

vizqx=Vinicio*ones(1,1+altinf-altsup);
vizqy=[altsup:altinf];

vderx=Vfin*ones(1,1+altinf-altsup);
vdery=[altsup:altinf];

% hold on;
% line(hsupx,hsupy,'LineWidth',3,'color','g');
% line(hinfx,hinfy,'LineWidth',3,'color','g');
% line(vizqx,vizqy,'LineWidth',3,'color','g');
% line(vderx,vdery,'LineWidth',3,'color','g');

line(hsupx,hsupy,'LineWidth',3,'color','g'),line(hinfx,hinfy,'LineWidth',3,'color','g'),line(vizqx,vizqy,'LineWidth',3,'color','g'),line(vderx,vdery,'LineWidth',3,'color','g');