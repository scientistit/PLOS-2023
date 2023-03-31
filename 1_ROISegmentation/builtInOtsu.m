function pic = builtInOtsu(pic,n)
    [~,~,z] = size(pic);

    if(z ~= 1)
        pic = rgb2gray(pic);
    end

    pic = im2double(pic);
    thresh = multithresh(pic,n);
    pic = imbinarize(pic,thresh);
end