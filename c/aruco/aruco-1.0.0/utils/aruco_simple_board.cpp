#include <iostream>
#include <getopt.h>
#include <fstream>
#include <sstream>
#include <opencv/cv.h>
#include <opencv/highgui.h>
#include "aruco.h"
#include "boarddetector.h"
#include "cvdrawingutils.h"
using namespace cv;
using namespace aruco; 
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
		if(argc<3) {cerr<<"Usage: image  boardConfig [cameraParams.yml] [markerSize]  [outImage]"<<endl;exit(0);}
		aruco::CameraParameters CamParam;
		MarkerDetector MDetector;
		vector<Marker> Markers;
		float MarkerSize=-1;
		BoardConfiguration TheBoardConfig;
		BoardDetector TheBoardDetector;
		Board TheBoardDetected;
		
		cv::Mat InImage=cv::imread(argv[1]);
		TheBoardConfig.readFromFile(argv[2]);
		if (argc>=4) CamParam.readFromXMLFile(argv[3]);
		//resizes the parameters to fit the size of the input image
		CamParam.resize( InImage.size());

		if (argc>=5) MarkerSize=atof(argv[4]);
		
		cv::namedWindow("in",1);
		MDetector.detect(InImage,Markers,CamParam,MarkerSize);
		//Detection of the board
		float probDetect=TheBoardDetector.detect( Markers, TheBoardConfig,TheBoardDetected, CamParam,MarkerSize);
			
		//for each marker, draw info and its boundaries in the image
		for(unsigned int i=0;i<Markers.size();i++){
			cout<<Markers[i]<<endl;
			Markers[i].draw(InImage,Scalar(0,0,255),2);
		}

		//draw a 3d cube in each marker if there is 3d info
		if (  CamParam.isValid()){
		  for(unsigned int i=0;i<Markers.size();i++){
		    CvDrawingUtils::draw3dCube(InImage,Markers[i],CamParam);
		  }
		  CvDrawingUtils::draw3dAxis(InImage,TheBoardDetected,CamParam);
		}
		//draw board axis
		
		//show input with augmented information
		cv::imshow("in",InImage);
		cv::waitKey(0);//wait for key to be pressed
		if(argc>=6) cv::imwrite(argv[5],InImage);
		
	}catch(std::exception &ex)

	{
		cout<<"Exception :"<<ex.what()<<endl;
	}

}