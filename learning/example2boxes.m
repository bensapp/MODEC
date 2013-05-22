function boxes = example2boxes(pts,armlength)
wh = 0.75*armlength;
boxes = box_from_dims(wh,wh,pts);