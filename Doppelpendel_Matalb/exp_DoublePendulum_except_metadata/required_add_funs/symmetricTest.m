function rescaleMat = symmetricTest(Mat)
    try 
        dMat = Mat-Mat';
        dMat_num = double(dMat);
        if all(dMat_num==0,'all')==1
            rescaleMat = 0;
        end
    catch
        rescaleMat = 1;
    end
end