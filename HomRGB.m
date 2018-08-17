function imgHom=HomRGB(img)

imgR=imadjust(img(:,:,1));
imgG=imadjust(img(:,:,2));
imgB=imadjust(img(:,:,3));

imgHom(:,:,1)=imgR;
imgHom(:,:,2)=imgG;
imgHom(:,:,3)=imgB;
