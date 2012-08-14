LSD - Line Segment Detector
===========================

by Rafael Grompone von Gioi, Jeremie Jakubowicz,
   Jean-Michel Morel and Gregory Randall.
Contact: grompone@gmail.com

Version 1.0, release of September 9, 2009.


Files
-----

lsd.c                             - LSD code

lena.pgm                          - Lena test image

lena.pgm.lsd.little-endian        - Result for Lena image as a Megawave2
                                    5-Flist file, for little-endian processors
                                    (Intel, etc.).

lena.pgm.lsd.little-endian.flists - Result for Lena image as a Megawave2 Flists
                                    file for visualization with 'fkview',
                                    for little-endian processors (Intel, etc.).

lena.pgm.lsd.big-endian           - Result for Lena image as a Megawave2
                                    5-Flist file, for big-endian processors
                                    (PowerPC, SPARC, etc.).

lena.pgm.lsd.big-endian.flists    - Result for Lena image as a Megawave2 Flists
                                    file for visualization with 'fkview',
                                    for big-endian processors
                                    (PowerPC, SPARC, etc.).

lena.pgm.lsd.txt                  - Result for Lena image as an ASCII file.

COPYING                           - GNU GENERAL PUBLIC LICENSE, Version 2.

README.txt                        - This file.


Compiling
---------

LSD can be compiled as an independent C program or as a Megawave2
module (http://megawave.cmla.ens-cachan.fr).

To be compiled as a Megawave2 module the file lsd.c must be put
in a Megawave2 source files directory and run the command:
  cmw2 -O3 lsd.c
The option '-O3' is recommended to optimize the final program for
improved running speed.

To compile LSD as an independent ANSI C program, use the following
compilation command:
  cc -DNO_MEGAWAVE -O3 -lm -o lsd lsd.c


Running
-------

When compiled as a Megawave2 module, many output options are
available, as can be seen by running the command without arguments ('lsd').
The simplest execution would be something like:
  lsd lena.pgm lena.pgm.lsd
The output file 'lena.pgm.lsd' would be a 5-Flist. Each vector would be
organized as (x1,y1,x2,y2,width), where the line segment start at the point
x1,y1 and ends at the point x2,y2. The last value is the width of the segment,
all in pixels units. The coordinates origin is at the center of pixel 0,0.

If the result is intended to be displayed using the 'fkview' Megawave2
command, LSD can be executed as follows:
  lsd -F lena.pgm.lsd.flists lena.pgm lena.pgm.lsd
This will produce, in addition to the 5-Flists file, the Flists file called
'lena.pgm.lsd.flists' that can be displayed with the command:
  fkview lena.pgm.lsd.flists
or, to be displayed over the image:
  fkview -i 0 -s -b lena.pgm lena.pgm.lsd.flists
The result can be tested with the provided results. On little-endian
architectures (for example with an Intel processor) the comparison
should be done with the following commands:
  diff lena.pgm.lsd.little-endian lena.pgm.lsd
  diff lena.pgm.lsd.little-endian.flists lena.pgm.lsd.flists
The files are identical if no output is obtained for the 'diff' execution.
On big-endian architectures (for example with a PowerPC or Sparc processsors)
the comparison should be done with the following commands:
  diff lena.pgm.lsd.big-endian lena.pgm.lsd
  diff lena.pgm.lsd.big-endian.flists lena.pgm.lsd.flists
Again, if the files are identical no output is obtained.
However, small differences may occurs, due to different computing precision.

To run LSD as an ANSI C language program it must be invoked
(assuming that it's included on the path) as:
  lsd lena.pgm
that would give the result to the standard output, or
  lsd lena.pgm lena.pgm.lsd.txt
to give the result on the file 'lena.pgm.lsd.txt'. The input image
must be in PGM format. In both cases, each line of the ASCII output
will be like the following:
  404.584503 182.640930 421.097992 121.843681 7.000000
that means that a line segment starting at point 404.584503,182.640930
and ending at point 421.097992,121.843681 and of width 7.000000 was
detected. When run as an ANSI C program, LSD can also produce a SVG
output. When executed without arguments, LSD prints a short help.


Running Options
---------------

The following are the options that can be set to LSD in
when used as Megawave2 module.

  Detection parameters:

  -s number
    If this option is used and a number different from 1.0 is
    used, the image is filtered and subsampling to the
    scale specified, previous to detecting line segments.
    A Gaussian filter is used to avoid aliasing.

  -c number
    When using the option '-s' the standard deviation for the
    Gaussian filter is chosen as sigma = number / scale (Default 0.7).

  -q number
    Bound to the quantization error of gradient norm.
    Used to adjust the threshold on the gradient norm. (Default 2.0)

  -d number
    Tolerance used on the level-line angles to group pixels into
    line-support regions. The angle tolerance used is Pi/number. (Default 8.0)

  -e number
    Detection threshold epsilon expressed as
    number = -log10(max. number of false alarms).
    The default value is 0.0 that corresponds to epsilon = 1.

  -b number
    The algorithm does a pseudo-ordering of gradient modulus.
    For that, pixels are classified into bins according to
    its gradient modulus. b is the number of bins to be used.
    The default value is 16256 and is selected to work well
    on images with gray levels in [0,255].

  -m number
    The algorithm does a pseudo-ordering of gradient modulus.
    For that, pixels are classified into bins according to
    its gradient modulus. The bins have values between
    zero and the parameter m, that indicates the highest
    gradient modulus. The default values is 260100 that
    corresponds to the highest gradient modulus on images
    with gray levels in [0,255].

  Debugging options:

  -v
    Verbose mode. Print information while processing.

  -x number
    Grow and test just one line-support region starting at
    point x,y with x=number. This option must be used with option -y.

  -y number
    Grow and test just one line-support region starting at
    point x,y with y=number. This option must be used with option -x.

  Output options:

  -r file
    Output a Cimage image to 'file' where the pixels of line-support regions
    are marked to the value 255, while the background is set to 0.

  -T
    Print to standard output the list of points for each region.

  -n number
    When using the option '-r' draw only the line-support region for
    the line segments number 'number'.

  -i file
    Output a Cimage image to 'file' with the value 255 on the line segments
    and 0 otherwise. 

  -F file
    Output the Flists 'file' with the line segments for visualization
    with the Megawave2 program 'fkview'.

  -R file
    Output the Flists 'file' with the rectangles for visualization
    with the Megawave2 program 'fkview'.

  -a
    When using the option '-R' it makes draw 'arrow heads'
    to the rectangles to show the direction.

  -A
    Output the line segments to standard output, one per line
    with the format 'x1 y1 x2 y2 width'.


Acknowledgment
--------------

The research was partially financed by the ALFA project CVFA II-0366-FA,
the Centre National d'Etudes Spatiales (CNES), the Office of Naval research
under grant N00014-97-1-0839 and Direction Generale de l'Armement.


Thanks
------

I would be grateful to receive any comment about errors, bugs, or strange
results.
