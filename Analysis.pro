pro Test
;window, 0, xsize=800, ysize=800
;wshow, 0
;plot, [0, 2047], [0, 2047], /nodata, /isotropic
top = fltarr(2048, 2048)*0
rotX = 1024
rotY = 1024
rotstep = 1.5
image = byte(indgen(2048, 2048))
for imgn = 1, 100 do begin
    print, "processing image ", imgn
    filename = String(imgn, Format='(I06)') + '.png'
    ;filename = String(1, Format='(I06)') + '.png'
    print, "filename ", filename
    ;READ_PNG, filename, image
    image = READ_BMP(filename)
    xsize = n_elements(image(*,0))
    ysize = n_elements(image(0,*))
    print, "image size ", xsize, " x ", ysize
    ;tv, image
    ;wait, 1
    w = where(image ge 250)
    ;xmax = 2048
    ;ymax = 600
    x = w MOD xsize
    y = w/ysize
    alpha = imgn*rotstep
    xreal = x - rotX
    yreal = y - rotY
    xrealrot = xreal*cos(alpha)
    yrealrot = xreal*sin(alpha)
    xtop = (xrealrot + rotX) > 0 < 2047
    ytop = (yrealrot + rotY) > 0 < 2047
    top(xtop, ytop) = yreal
    oplot, x, y, psym=3, color= 128+(imgn*7) MOD 128
    x = 0
    y = 0
    image = 0
    ;if ((imgn mod 10) EQ 9) then stop
    end
    stop
end

pro Analysis, a
print, a
end
