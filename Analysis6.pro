pro Analysis, cutoff = cutoff
if n_elements(cutoff) eq 0 then cutoff = 100

;These initialize the aray, fixed values for output size
top = fltarr(2048, 2048)*0
top_int = top
top_cnt = top


rotX = 1024
rotY = 1024
image = byte(indgen(2048, 2048))

start_frm = 60
end_frm = 5319
frames = end_frm - start_frm + 1
rotstep = 2*!pi/frames
rot_sub = 1.0/(2048/2)
sub_n = rotstep / rot_sub

; this loop reads in all the images and prints a progress message
for imgn = 0, frames-1 do begin
    percent = 100.0*imgn/frames
    if (imgn MOD 10) eq 0 then print, Format='($, A, A, I3, A)', String(13B), "Processing at,", percent, "% completion."
    filename = String(imgn + start_frm, Format='(I06)') + '.png'
    image = READ_BMP(filename)

   ;These two lines detect image size
    xsize = n_elements(image(*,0))
    ysize = n_elements(image(0,*))
    dmx = xsize
    dmy = ysize

; This line finds all the pixels greater than a certain intensity
    w = where(image ge 100)

    x = w MOD xsize
    y = w/ysize

    xreal = x - (dmx/2)
    yreal = y - (dmy/2)
    ;This next line flips the axis for pictures that are upside down
    yreal = (dmy/2) - yreal

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

print, " "
print, "Processing at, 100% completion"
print, "Continue to display array data."
    stop
tvscl, congrid(top, 500, 500)

    print, "Please close view window and contine to generate surface plot."
stop

    surface, smooth(congrid(top, 300, 300), 2), ax = 75, az = 15
stop

end

pro disp_cs, top, ypos
xarr = indgen(2048, 2048)mod 2048
yarr = transpose(xarr)
if n_elements(ypos) EQ 0 then ypos = 1024
mmscale=156.0/1200.0
plot, xarr(*, ypos)*mmscale, top(*, ypos)*mmscale/1.0*0.13, /isotropic, xrange=[420, 1620]*mmscale, xstyle=1



end

;surface, smooth(congrid(top(400:1600, 400:1600), 150, 150), 2), zrange=[-150, 50], ax=45, az=35, zstyle=1, t3d
;t3d, rotate=[x,y,z]
;depth of bowl = 35.2mm
;inner width of bowl = 156mm
