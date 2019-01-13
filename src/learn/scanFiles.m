function [lx,ly,rx,ry,Inames,looking] = scanFiles(PATH)
    a = dir(strcat(PATH,'*.eye'));
    nf = size(a);
    lx = zeros(nf);ly = zeros(nf);rx = zeros(nf);ry = zeros(nf);
    for i = 1:nf 
        filename = horzcat(a(i).folder,'/',a(i).name);
        fid = fopen(filename);
        s = textscan(fid, '%s', 1, 'delimiter', '\n');
        c = textscan(fid, '%d', 4, 'delimiter', ' ');
        lx(i) = c{1}(1);ly(i) = c{1}(2);rx(i) = c{1}(3);ry(i) = c{1}(4); 
        fclose(fid);
    end

    a = dir(strcat(PATH,'/*.pgm'));
    nf = size(a);
    Inames = strings(nf);
    for i = 1:nf
        Inames(i) =char(horzcat(a(i).folder,'/',a(i).name));
    end
    looking = xlsread(strcat(PATH,'Miram.xlsx'), 'E5:E1525');
end