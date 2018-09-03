clf;

clear all;

//str = 'Pos_0.txt';
str = 'Pos_3.txt';
//str = 'tbOutData.txt';
tbdata = csvRead(str,ascii(9), [], 'string');

fs = 250000;
[n m]=size(tbdata);
data= bin2dec(tbdata);
mat = []
N = length(data)/61;
for k=0:N-1
   beam = data(k*61+1: (k+1)*61) - 2^17;
   mat = [mat abs(beam)]
end

D = 512

mat = mat(:,48:1024);
[x,y] = size(mat)

t = 0:1/fs:(y-1)/fs;
theta = -30:1:30;
t = t*1000;
mat = mat./max(mat);
mat = D*mat;
mat = int(mat)
scf(0)
plot3d(theta,t,mat)
h=get("hdl") //get handle on current entity (here the surface)
a=gca(); //get current axes
a.rotation_angles=[35,-30];
a.box="off"
//a.grid=[1 1 1];
//make grids
a.axes_visible="on";
//axes are hidden a.axes_bounds=[.2 0 1 1];
f=get("current_figure");
//get the handle of the parent figure
//f.color_map=bonecolormap(512)
//f.color_map=coppercolormap(512);
//f.color_map=hotcolormap(128); 
f.color_map=jetcolormap(D); 


//change the figure colormap
h.color_flag=1;
//color according to z
h.color_mode=-1;
//remove the facets boundary
h.color_flag=1;
//color according to given colors
//h.data.color=[1+modulo(1:400,64),1+modulo(1:400,64)];
//shaded
h.color_flag=1;

outstr = str + '.svg'
xs2svg(0, outstr)

//csvWrite(mat', "angle0.txt");

