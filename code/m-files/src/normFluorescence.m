function [normIntensity, relIntensity]=normFluorescence(blue_row)

    max_blue=max([max(blue_row1), max(blue_row2), max(blue_row3)]);
    max_yellow=max([max(yellow_row1), max(yellow_row2), min(yellow_row3)]);
    min_blue=min([min(blue_row1), min(blue_row2), min(blue_row3)]);
    min_yellow=min([min(yellow_row1), min(yellow_row2), min(yellow_row3)]);

    norm_blue_row1=(blue_row1-min(blue_row1))./(max(blue_row1)-min(blue_row1));
    norm_blue_row2=(blue_row2-min(blue_row2))./(max(blue_row2)-min(blue_row2));
    norm_blue_row3=(blue_row3-min(blue_row3))./(max(blue_row3)-min(blue_row3));

    norm_yellow_row1=(yellow_row1-min(yellow_row1))./(max(yellow_row1)-min(yellow_row1));
    norm_yellow_row2=(yellow_row2-min(yellow_row2))./(max(yellow_row2)-min(yellow_row2));
    norm_yellow_row3=(yellow_row3-min(yellow_row3))./(max(yellow_row3)-min(yellow_row3));

    normIntensity_row1=[norm_blue_row1; norm_yellow_row1]';
    relIntensity_row1=normIntensity_row1./sum(normIntensity_row1,2);

    normIntensity_row2=[norm_blue_row2; norm_yellow_row2]';
    relIntensity_row2=normIntensity_row2./sum(normIntensity_row2,2);

    normIntensity_row3=[norm_blue_row3; norm_yellow_row3]';
    relIntensity_row3=normIntensity_row3./sum(normIntensity_row3,2);
