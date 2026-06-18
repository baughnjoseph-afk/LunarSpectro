pro Analysis, cutoff = cutoff
if n_elements(cutoff) eq 0 then cutoff = 100

;These initialize the aray, fixed values for output size
top = fltarr(2048, 2048)*0
top_int = top
top_cnt = top


rotX = 1024
rotY = 1024
image = byte(indgen(2048, 2048))

start_frm = 1
end_frm = 5791
frames = end_frm - start_frm + 1
rotstep = 2*!pi/frames
rot_sub = 1.0/(2048/2)
sub_n = rotstep / rot_sub

for imgn = 0, frames-1 do begin
    percent = 100.0*imgn/frames
    if (imgn MOD 10) eq 0 then print, "Processing at,", percent, "% completion."
    ;print, "processing image number/name", imgn, "/", imgn + start_frm
    filename = String(imgn + start_frm, Format='(I06)') + '.png'
    ;print, "filename ", filename
    ;READ_PNG, filename, image



   image = READ_BMP(filename)
   ;These two lines detect image size
    xsize = n_elements(image(*,0))
    ysize = n_elements(image(0,*))
    dmx = xsize
    dmy = ysize
  ;  print, "image size ", xsize, " x ", ysize
; This line finds all the pixels greater than a certain intensity
    w = where(image ge 100)

    x = w MOD xsize
    y = w/ysize
    xreal = x - (dmx/2)
    yreal = y - (dmy/2)

;careful, exceeding 6000 frames will make sub_n less than 1
for sn = 0, sub_n - 1 do begin
    alpha = imgn*rotstep + sn*rot_sub
    xrealrot = xreal*cos(alpha)
    yrealrot = xreal*sin(alpha)
    xtop = (xrealrot + rotX) > 0 < 2047
    ytop = (yrealrot + rotY) > 0 < 2047
    top_int(xtop, ytop) += yreal
    top_cnt(xtop, ytop) += 1
endfor
    x = 0
    y = 0
    image = 0
    ;if ((imgn mod 10) EQ 9) then stop
endfor

    w = where(top_cnt NE 0)
    top(w) = top_int(w)/top_cnt(w)

print, "Continue to display array data."
    stop
tvscl, congrid(top, 500, 500)

    ;top2 = top
    ;w2 = where(top gt cutoff)
    ;top2(w2) = 0
    ;top2red = congrid(top2, 200, 200)
    ;y = findgen(dmx, dmy)/dmy
    ;x = findgen(dmx, dmy) mod dmy
    ;cx = dmx/2 & cy = dmy/2
    ;dist2 = (x-cx)^2 + (y-cy)^2
    ;cut = 550.0 &  w = where(dist2 gt cut^2) & top3 = top2 & top3(w) = 0

    print, "Please close view window and contine to generate surface plot."
stop
    ;top3red = congrid(top3(cx-cut:cx+cut, cy-cut:cy+cut), 200, 200)
    ;surface, smooth(top3, 2), ax = 85, az = 15
    surface, smooth(top, 2), ax = 45, az = 45
stop

end
