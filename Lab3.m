clear all;clc; close all;

lee_archivos = dir('mobile\*.tiff'); % Folder where the images are stored
nombre='mobile\'; %Route of the images 
nombre2='mobile_coded\';
numFrames=12; %Only for time. It lasts around 20 minutes to code-decode for all the frames

%Acquisition of frames
for k=1:numFrames
    
    archivo = lee_archivos(k).name;
    I= im2double(imread(strcat(nombre,archivo))); %String cat of the route and the number of the File
    frames(:,:,k)=I(:,:,1);
    
end

%Declaration of indexes
m=3;%Anchors
n=12;%GOP
quality=1;

%Coding
frame_I= frames(:,:,1);
disp('Codificación inicial de I');
coded_frame= I_Coder(frame_I, quality);
coded_I(1)= struct('coded',coded_frame);


for i=1:n:numFrames %Sweep the subset of frames
    for p=i+m:m:i+n %Sweep for possibles P or I
        if p <= numFrames %Condition for the subset
            
        
            if p == i+n %Implies a I frame (n is group of pictures
                frame1 = frame_I;
                frame2 = frames(:,:,p);
                disp(['Codificación de frame I, numero',num2str(p)]);
                cod_frame = I_Coder(frame2, quality);
                
                coded_I(p) = struct('coding', cod_frame);
                
            else %IMplies a P frame
                     
                frame1 = frame_I;
                frame2 = frames(:,:,p);
                disp(['Codificación de frame P, numero ',num2str(p)]);
                [mv, dct_error] = P_Coder(frame2, frame1, quality);
                
                coded_P(p) = struct('motionVector', mv, 'predError', dct_error);
                 
            end
            
            for b = p-1:-1:p-(m-1) % Implies the other frames (B frames)
                frame3 = frames(:,:,b);
                disp(['Codificacion B-frame ',num2str(b)]);
                [mv1, mv2, dct_error] = B_coder(frame3, frame1, frame2, quality);
                coded_B(b) = struct('motionVector1', mv1,'motionVector2', mv2, 'predError', dct_error);
            end
           
            end
    end
        
end



%Decoder
frame_I = coded_I(1);
disp('Decodificación I-frame_I 1');
frame2 = I_decoder(frame_I, quality);
decod_frames(:,:,1) = frame2;



for i = 1:n:9
    for p = i+m:m:i+n
        if p <= numFrames
            if p == i+n && (i+n)<12 %Condition of subset
              frame_I = coded_I(p);
                frame1 = frame2;
                disp(['Decodificación frame  ',num2str(p)]);
                frame2 = I_decoder(frame_I, quality);
                decod_frames(:,:,p) = frame2;
                
            else
                
                frame_I = coded_P(p);
                frame1 = frame2;
                disp(['Decodifiacion P ',num2str(p)]);
                frame2 = P_decoder(frame_I, frame1, quality);
                decod_frames(:,:,p) = frame2;
            end
        
            for b = p-1:-1:p-(m-1)
                frame_I = coded_B(b);
                disp(['Decodificacion B ',num2str(b)]);
                decod_frames(:,:,b) = B_decoder(frame_I, frame1, frame2, quality);               
            end
        end
    end
end

mkdir('mobile_coded')
for k=1:10
    
    archivo = lee_archivos(k).name;
    imwrite(decod_frames(:,:,k),[nombre2,archivo],'jpg') ; %String cat of the route and the number of the File
   
    
end
        
