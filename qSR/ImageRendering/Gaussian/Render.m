function ImOut = Render(Xpos,Ypos,num_pix,sigma_render,show_figure)

if nargin < 5
   show_figure = true; 
end

[r,c] = size(Xpos);
if c == 1
    Xpos = Xpos'; %Ensures that input is a row vector.
    Ypos = Ypos'; %Ensures that input is a row vector.
end


Xmin = min(Xpos);Xmax=max(Xpos);Ymin = min(Ypos);Ymax=max(Ypos);
delt_X=Xmax-Xmin;delt_Y=Ymax-Ymin;
delta=max(delt_X,delt_Y);
dxy=delta/num_pix;

Edges{1}=Xmin:dxy:Xmax;
Edges{2}=Ymin:dxy:Ymax;

Im = hist3([Xpos',Ypos'],'Edges',Edges);

TempX=-round(3*sigma_render/dxy)*dxy:dxy:round(3*sigma_render/dxy)*dxy;
TempY=-round(3*sigma_render/dxy)*dxy:dxy:round(3*sigma_render/dxy)*dxy;

ConVecX = exp(-0.5*(TempX/sigma_render).^2);
ConVecX=ConVecX/sum(ConVecX);
ConVecY = exp(-0.5*(TempY/sigma_render).^2);
ConVecY=ConVecY/sum(ConVecY);
Im2 = conv2(ConVecX,ConVecY,Im);
Im2=Im2/dxy/dxy*10^6;%/max(max(Im2));

extra_pixels=(size(Im2)-size(Im))/2;

Im2=Im2((extra_pixels(1)+1):(end-extra_pixels(1)),(extra_pixels(2)+1):(end-extra_pixels(2)));
Im2=Im2(:,end:-1:1)';

ImOut=Im2;

if show_figure

    figure
    imshow(ImOut,'colormap',hot)
    h=colorbar;
    xlabel(h,'Localizations/um^2','FontSize',14)
    imcontrast(gca)
    
end


