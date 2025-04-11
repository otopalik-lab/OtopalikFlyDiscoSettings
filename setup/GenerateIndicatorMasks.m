% Make LED Indiciator Template and Masks:

%% Change these file paths as needed:
analysis_protocol = '20250307_fourbubbleobject_CsChrimson'; %name of settings directory of interest
expdir = '/Volumes/otopaliklab/Temporary_Storage/Chelo/fourbubbleobject_multibubble__Red_2min_p1-cs_UASChrimsonVenusX0070_20250218T133738';

%% Do not change if setting up in OtopalikFlyDiscoSettings:
settingsdir = '/Users/perezsanchezc/Documents/GitHub/OtopalikFlyDiscoSettings/settings';
%analysis_protocol = '20240912_MultibubbleMaleMale';
%expdir = '/Volumes/otopaliklab/flydisco_data/2024-08-12/MultibubbleMaleMale_multibubble__RedStepsOnOff6Steps_3020171_UASChrimsonVenusX0070_20240812T131019';
datalocparamsfilestr = 'dataloc_params.txt';
dataloc_params = ReadParams(fullfile(settingsdir,analysis_protocol,datalocparamsfilestr));
cd(expdir)
%% To make LED template image:

moviefilename = fullfile(expdir,dataloc_params.moviefilestr);

[readfcn,nframes,fid,headerinfo] = get_readframe_fcn(moviefilename);
im = readfcn(1);
% for j = 1:100:(headerinfo.nframes/5)
for j = 1:10:(headerinfo.nframes)
    tmp = readfcn(j);
    idx = tmp > im;
    im(idx) = tmp(idx);
    if (mod(j,1000) == 0);
        disp(round((j/headerinfo.nframes)*100))
    end
end

% grab a rectangle around the marker to make a template
mu = im;
figure(1);
clf;
imagesc(mu);
axis image;
r = getrect;
xlim = round(r(1)+[0,r(3)]);
ylim = round(r(2)+[0,r(4)]);
hold on;
plot(xlim([1,1,2,2,1])+.5*[-1,-1,1,1,-1],ylim([1,2,2,1,1])+.5*[-1,1,1,-1,-1],'w-','linewidth',2);

template = mu(ylim(1):ylim(2),xlim(1):xlim(2));
figure(2);
imagesc(template);
axis image;

%%%%%%%%% change output file name; copy into analysis protocol directory and edit registration_params.LEDMarkerType  %%%%%%%%%%%%%%%%
cd(fullfile(settingsdir,analysis_protocol))
imwrite(uint8(template),'LEDTemplates_fourbubble_CsChrimson.png');

% distance from the corner 
% informative for setting registration_params.maxDistCornerFrac_LEDLabel (restricts template
% matching to smaller area)
x = mean(xlim);
y = mean(ylim);
nc = headerinfo.nc;
nr = headerinfo.nr;
corners = [1,1,nc,nc;1,nr,nr,1];
dcorner = sqrt(min((corners(1,:)-x).^2 + (corners(2,:)-y).^2));
imr = min(nr,nc);
dcornerfrac = dcorner / imr

%% To make masks for multicolor optogenetics (for each LED have to rename .png to mask_1, mask_2, etc.)
% read in LED template made in earlier step
image = imread('LEDTemplates_fourbubble_CsChrimson.png');

figure
imshow(image);
title('Draw a circle and double-click to confirm');

h = drawcircle();

binarymask = createMask(h);

% show template and mask

figure
subplot(1, 2, 1), imshow(image), title('LED template image');
subplot(1, 2, 2), imshow(binarymask), title('Binary Mask');

% i think 'mask_1' is controlled vocabulary
imwrite(uint8(binarymask*255),'LEDTemplates_CsChrimson_mask_1.png')


