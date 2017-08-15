---
layout: post
title: "Timelapse of Tappan Zee Bridge"
date:   2017-08-15 00:00:00 -0000
categories: engineering
---

<video controls="controls" allowfullscreen="true" loop="true" poster="/images/tz_timelapse.jpg" width="100%" height="100%" border="0">
  <source src="/images/tz_timelapse.mp4" type="video/mp4">
</video>

<!--more-->
Neither automatic alignment with Photoshop panorama tools nor *align_image_stack* from Hugin worked, probably because there are too many differences between the first and the last frame. So I had to align manually using the following process:

* Create a spreadsheet with the list of image files;
* Find two easily identifiable key points, one near upper left corner, another near upper right corner;
* Open each file in Photoshop, hover mouse pointer over the left key point, record x<sub>0</sub> and y<sub>0</sub> coordinates (in pixels) from the info pane, do the same with the right key point, record x<sub>1</sub> and y<sub>1</sub>;
* Using formulas in spreadsheet, create ImageMagick commands;
* Copy and paste commands from the spreadsheet in terminal.

Example:

    convert 
      orig/2013_0527_1104.tif 
      -extent 5178x3652-241-1231 
      -rotate 0.368461030248915 
      -crop 3008x1692+398+1500
      -resize 1920x1080 
      aligned/frame11040.png

This command does the following:

* Add border around the image so that the right key point is in the middle;
* Rotate the image so that the line between the key points is at the same angle relative to the horizon;
* Crop the image to target aspect ratio;
* Resample to video resolution.

To get rotation angle, start by calculating the angle &alpha; between the horizon and the line connecting the key points: &alpha; = 180&deg; &middot; atan((y<sub>1</sub> - y<sub>0</sub>) / (x<sub>1</sub> - x<sub>0</sub>)) / &pi;, then subtract average &alpha;. To cancel out this rotation, rotate the image in the opposite direction (flip the sign).

To add panning, keep shifting the frame by a small amount when cropping.

To get smooth transitions, add interpolating frames obtained by blending consecutive frames. Example:

    composite 
      -blend 66x34 
      aligned/frame11043.png 
      aligned/frame16170.png 
      -alpha Set 
      inter/frame11041.png

When all frames are ready, combine them into a video using ffmpeg:

    ffmpeg 
      -framerate 6 
      -i 'inter/frame%*.png' 
      -pix_fmt yuv420p
      -c:v libx264 
      -r 6 
      tz_timelapse.mp4

[Direct link]({{ site.url }}/images/tz_timelapse.mp4) to video file.

