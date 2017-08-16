function ResizeFigure(newSize,isCut,varargin)
    if isempty(varargin)
        filePath = uigetdir();
        savePath = uigetdir(filePath,'Please select save path...');
    else
        filePath = varargin{1};
        savePath = varargin{2};
    end
    jpgFiles = dir(strcat(filePath,'\*.jpg'));
    jpegFiles = dir(strcat(filePath,'\*.jpeg'));
    
    numL = length(jpgFiles);
    numM = length(jpegFiles);
    
    h = waitbar(0,'Processing...');
    
    for m = 1:1:numL
        if isCut
            tmp = processImg(imread(strcat(filePath,'\',jpgFiles(m).name)),newSize);
        else
            tmp = imresize(imread(strcat(filePath,'\',jpgFiles(m).name)),newSize);
        end
        waitbar(m/(numL+numM),h);
        imwrite(tmp,strcat(savePath,'\',num2str(m),'.jpg'),'jpg');
    end
     
    for m = 1:1:numM
        if isCut
            tmp = processImg(imread(strcat(filePath,'\',jpegFiles(m).name)),newSize);
        else
            tmp = imresize(imread(strcat(filePath,'\',jpegFiles(m).name)),newSize);
        end
        waitbar((numL + m)/(numL+numM),h);
        imwrite(tmp,strcat(savePath,'\',num2str(numL + m),'.jpg'),'jpg');
    end
    
    close(h);
    
end

function im = processImg(imMat,newSize)
    [imH,imW,~] = size(imMat);
    targetHWRatio = newSize(1)/newSize(2);
    originHWRatio = imH/imW;
    
    if abs(targetHWRatio - originHWRatio) < 0.01
        im = imMat;
        return;
    end
    
    if targetHWRatio > originHWRatio
        newImW = round(imH/targetHWRatio);
        if mod(newImW,2) == 1
            newImW = newImW + 1;
        end
        stater = round((imW - newImW)/2);
        ender = stater + newImW - 1;
        if stater < 1
            im = imMat;
            return;
        end
        im = imresize(imMat(:,stater:ender,:),newSize);
    else
        newImH = round(imW * targetHWRatio);
        if mod(newImH,2)==1
            newImH = newImH + 1;
        end
        stater = round((imH - newImH)/2);
        ender = stater + newImH - 1;
        if stater < 1
            im = imMat;
            return;
        end
        im = imresize(imMat(stater:ender,:,:),newSize);
    end
end

