.PHONY: video.mp4 video.gif clean

video.mp4:
	ffmpeg -r 25 -f image2 -s 1920x1080 -i frame%05d.png -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -crf 25  -pix_fmt yuv420p $@

video.gif:
	ffmpeg -framerate 5 -f image2 -s 1920x1080 -i frame%05d.png -loop 0 $@

clean:
	rm -f *.mp4 *.png
