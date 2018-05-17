function outputPic = correlationWithBilateralFilter( imgMatrix, GFilter )
%输入一个图像矩阵和一个高斯滤波器，输出经过双边滤波器的图像矩阵
%双边滤波器的spatial kernel在函数中实现

[rows, columns, nDimension] = size(imgMatrix);                  %读取图像长宽和通道数
imgMatrix = double(imgMatrix);
filterLength = size(GFilter, 1);                                 %默认方形滤波器
floorHalfLength = floor(filterLength / 2);
ceilHalfLength = ceil(filterLength / 2);
outputPic = zeros(rows, columns, nDimension);                   %预分配空间，操作最后再裁剪

%sigmoidOffset = 5;

%按照定义，没有优化
for d = 1 : nDimension
    for r = ceilHalfLength : rows - floorHalfLength
        for c = ceilHalfLength : columns - floorHalfLength
            
            centerPointValue = imgMatrix(r, c, d);
            originMatrix = imgMatrix(r - floorHalfLength : r + floorHalfLength, c - floorHalfLength : c + floorHalfLength, d);
            
            %曲线可以调整，尝试采用可以调整的sigmoid函数
            
            %sigmoid
%             tempEXP = exp(-(abs(originMatrix - centerPointValue) - sigmoidOffset));
%             spatialKernelFunction = tempEXP / (1 + tempEXP);

            %linear
%            spatialKernelFunction = -abs(originMatrix - centerPointValue) / 255 + 1;

            %threshold
            spatialKernelFunction = abs(originMatrix - centerPointValue);
            %此处设置阈值，可能可以作为函数参数或者用自适应的方法确定
            spatialKernelFunction(spatialKernelFunction < 50) = 1;
            spatialKernelFunction(spatialKernelFunction ~= 1) = 0;
            
            BFilter = spatialKernelFunction .* GFilter;
            
            %归一化
            k = sum(BFilter(:));
            BFilter = BFilter / k;
            
            tempMatrix = originMatrix .* BFilter;
            outputPic(r, c, d) = sum(tempMatrix(:));
        end
    end
end

%裁剪
outputPic = outputPic(ceilHalfLength : rows - floorHalfLength, ceilHalfLength : columns - floorHalfLength, :);
%转换为uint8才能正常显示
outputPic = uint8(outputPic);

end

