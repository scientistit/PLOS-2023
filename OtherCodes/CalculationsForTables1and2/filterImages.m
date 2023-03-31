function filteredImage = filterImages(I,name)
filter = fspecial(name);
filter = transpose(filter);
filteredImage = imfilter(I,filter,'replicate');
end