#include <iostream>
#include <getopt.h>
#include <fstream>
#include <sstream>
#include <opencv2/opencv.hpp>
#include "aruco.h" 
using namespace cv;
using namespace aruco;

string TheInputVideo;
string TheIntrinsicFile;
string TheBoardConfigFile;
bool The3DInfoAvailable=false;
bool isIntrinsicFileYAML=false;
float TheMarkerSize=-1;
MarkerDetector MDetector;
VideoCapture TheVideoCapturer;
vector<Marker> TheMarkers;
Mat TheInputImage,TheInputImageCopy;
CameraParameters TheCameraParameters;
BoardConfiguration TheBoardConfig;
BoardDetector TheBoardDetector;
Board TheBoardDetected;
string TheOutVideoFilePath;
cv::VideoWriter VWriter;

void cvTackBarEvents(int pos,void*);
void readArguments ( int argc,char **argv );
void usage();
pair<double,double> AvrgTime(0,0) ;//determines the average time required for detection
double ThresParam1,ThresParam2;
int iThresParam1,iThresParam2;
/************************************
 *
 *
 *
 *
 ************************************/
int main(int argc,char **argv)
{
	try
	{
	      if(argc==1) usage();
		//parse arguments
		readArguments (argc,argv);
		//read board config info
		if(TheBoardConfigFile==""){
		  cerr<<"The board configuration info must be provided (-b option)"<<endl;
		  return -1;
		}
		TheBoardConfig.readFromFile(TheBoardConfigFile);
		 //read from camera or from  file
		if (TheInputVideo=="") TheVideoCapturer.open(0);
		else TheVideoCapturer.open(TheInputVideo);
		//check video is open
		if (!TheVideoCapturer.isOpened()){
		  cerr<<"Could not open video"<<endl;
		  return -1;
		  
		}

		//read first image to get the dimensions
		TheVideoCapturer>>TheInputImage;

		//Open outputvideo
		if ( TheOutVideoFilePath!="")
		  VWriter.open(TheOutVideoFilePath,CV_FOURCC('M','J','P','G'),15,TheInputImage.size());
		
		//read camera parameters if passed
		if (TheIntrinsicFile!=""){
		  if (isIntrinsicFileYAML)
		    TheCameraParameters.readFromXMLFile(TheIntrinsicFile);
		  else
		    TheCameraParameters.readFromFile(TheIntrinsicFile);
		    TheCameraParameters.resize(TheInputImage.size());
		} 
		
		//Create gui
		
		cv::namedWindow("thres",1);
		cv::namedWindow("in",1);
		MDetector.getThresholdParams( ThresParam1,ThresParam2);
		iThresParam1=ThresParam1;iThresParam2=ThresParam2;
		cv::createTrackbar("ThresParam1", "in",&iThresParam1, 13, cvTackBarEvents);
		cv::createTrackbar("ThresParam2", "in",&iThresParam2, 13, cvTackBarEvents);
		char key=0;
		int index=0;
		//capture until press ESC or until the end of the video
		while( key!=27 && TheVideoCapturer.grab())
		{
			TheVideoCapturer.retrieve( TheInputImage);  
			TheInputImage.copyTo(TheInputImageCopy);
			index++; //number of images captured
			double tick = (double)getTickCount();//for checking the speed
			//Detection of markers in the image passed
			MDetector.detect(TheInputImage,TheMarkers,TheCameraParameters);
			//Detection of the board
			float probDetect=TheBoardDetector.detect( TheMarkers, TheBoardConfig,TheBoardDetected, TheCameraParameters,TheMarkerSize);
			//chekc the speed by calculating the mean speed of all iterations
			AvrgTime.first+=((double)getTickCount()-tick)/getTickFrequency();
			AvrgTime.second++;			
			cout<<"Time detection="<<1000*AvrgTime.first/AvrgTime.second<<" milliseconds"<<endl;			
			//print marker borders
			for(unsigned int i=0;i<TheMarkers.size();i++)
				TheMarkers[i].draw(TheInputImageCopy,Scalar(0,0,255),1);
			
			//print board
			if (TheCameraParameters.isValid()){
			  if ( probDetect>0.2)   {
			    CvDrawingUtils::draw3dAxis( TheInputImageCopy,TheBoardDetected,TheCameraParameters);
				//draw3dBoardCube( TheInputImageCopy,TheBoardDetected,TheIntriscCameraMatrix,TheDistorsionCameraParams);
				}
			}
			  //DONE! Easy, right?

			cout<<endl<<endl<<endl;
			//show input with augmented information and  the thresholded image
			cv::imshow("in",TheInputImageCopy);			
			cv::imshow("thres",MDetector.getThresholdedImage());
			//write to video if required
			if (  TheOutVideoFilePath!=""){
			  //create a beautiful compiosed image showing the thresholded
			  //first create a small version of the thresholded image
			  cv::Mat smallThres;
			  cv::resize( MDetector.getThresholdedImage(),smallThres,cvSize(TheInputImageCopy.cols/3,TheInputImageCopy.rows/3));
			  cv::Mat small3C;
			  cv::cvtColor(smallThres,small3C,CV_GRAY2BGR);
			  cv::Mat roi=TheInputImageCopy(cv::Rect(0,0,TheInputImageCopy.cols/3,TheInputImageCopy.rows/3));
 			  small3C.copyTo(roi);
			  VWriter<<TheInputImageCopy;
// 			 cv::imshow("TheInputImageCopy",TheInputImageCopy);			
			
			}

			key=cv::waitKey(0);//wait for key to be pressed
		}
		
		
	}catch(std::exception &ex)

	{
		cout<<"Exception :"<<ex.what()<<endl;
	}

}
/************************************
 *
 *
 *
 *
 ************************************/

void cvTackBarEvents(int pos,void*)
{
if (iThresParam1<3) iThresParam1=3;
if (iThresParam1%2!=1) iThresParam1++;
if (ThresParam2<1) ThresParam2=1;
ThresParam1=iThresParam1;
ThresParam2=iThresParam2;
MDetector.setThresholdParams(ThresParam1,ThresParam2);
//recompute
MDetector.detect(TheInputImage,TheMarkers,TheCameraParameters ,TheMarkerSize);
//Detection of the board
float probDetect=TheBoardDetector.detect( TheMarkers, TheBoardConfig,TheBoardDetected, TheCameraParameters);
if (TheCameraParameters.isValid() && probDetect>0.2) 
  aruco::CvDrawingUtils::draw3dAxis(TheInputImageCopy,TheBoardDetected,TheCameraParameters);

cv::imshow("in",TheInputImageCopy);			
cv::imshow("thres",MDetector.getThresholdedImage());
}

/************************************
 *
 *
 *
 *
 ************************************/
void usage()
{
	cout<<"This program test the ArUco Library \n\n";
	cout<<"-i <video.avi>: specifies a input video file. If not, images from camera are captures"<<endl;
	cout<<"-b <boardConfiguration.abc>: file with the board configuration"<<endl;
	cout<<"-f <file.int>: if you have calibrated your camera, pass calibration information here so as to be able to get 3D marker info"<<endl;
	cout<<"-y <file.yml>: if you have calibrated your camera in yml format as provided by the calibration.cpp aplication in OpenCv >= 2.2"<<endl;
	cout<<"-s <size>: size of the marker's sides (expressed in meters!)"<<endl;
	cout<<"-o video.avi: output video"<<endl;
}

/************************************
 *
 *
 *
 *
 ************************************/
static const char short_options [] = "hi:f:s:b:o:y:";

static const struct option
long_options [] =
{
	{ "help",           no_argument,   NULL,                 'h' },
	{ "input",     required_argument,   NULL,           'i' },
	{ "intFile",     required_argument,   NULL,           'f' },
	{ "YAMLFile",     required_argument,   NULL,           'y' },
	{ "boardFile",     required_argument,   NULL,           'b' },
	{ "size",     required_argument,   NULL,           's' },
	{ "output",     required_argument,   NULL,           'o' },

	{ 0, 0, 0, 0 }
};

/************************************
 *
 *
 *
 *
 ************************************/
void readArguments ( int argc,char **argv )
{
	for ( ;; )
	{
		int index;
		int c;
		c = getopt_long ( argc, argv,
			short_options, long_options,
			&index );

		if ( -1 == c )
			break;
		switch ( c )
		{
			case 0:
				break;
			case 'h':
				usage ();
				exit ( EXIT_SUCCESS );
				break;
			case 'i':
				TheInputVideo=optarg;
				break;
			case 'f':
				TheIntrinsicFile=optarg;
				isIntrinsicFileYAML=false;
				break;
			case 'y':
				TheIntrinsicFile=optarg;
				isIntrinsicFileYAML=true;
				break;
			case 's':
				TheMarkerSize=atof(optarg);
				break;
			case 'b':
				TheBoardConfigFile=optarg;
				break;
			case 'o':
				TheOutVideoFilePath=optarg;
				break;
			default:
				usage ();
				exit ( EXIT_FAILURE );
		};
	}

}
