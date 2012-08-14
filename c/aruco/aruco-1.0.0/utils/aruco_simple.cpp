#include <iostream>
#include "aruco.h"
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
		if(argc<3) {cerr<<"Usage: in.jpg [cameraParams.yml] [markerSize] [outImage]"<<endl;exit(0);}
		aruco::CameraParameters CamParam;
		MarkerDetector MDetector;
		vector<Marker> Markers;
		float MarkerSize=-1;
		cv::Mat InImage=cv::imread(argv[1]);
		if (argc>=3) CamParam.readFromXMLFile(argv[2]);
		//resizes the parameters to fit the size of the input image
		CamParam.resize( InImage.size());
		
		if (argc>=4) MarkerSize=atof(argv[3]);
		cv::namedWindow("in",1);
		MDetector.detect(InImage,Markers,CamParam,MarkerSize);
		//for each marker, draw info and its boundaries in the image
		for(unsigned int i=0;i<Markers.size();i++){
			cout<<Markers[i]<<endl;
			Markers[i].draw(InImage,Scalar(0,0,255),2);
		}

		//draw a 3d cube in each marker if there is 3d info
		if (  CamParam.isValid())
		  for(unsigned int i=0;i<Markers.size();i++){
		    CvDrawingUtils::draw3dCube(InImage,Markers[i],CamParam);
		  }
		//show input with augmented information
		cv::imshow("in",InImage);
		cv::waitKey(0);//wait for key to be pressed
		if(argc>=5) cv::imwrite(argv[4],InImage);
	}catch(std::exception &ex)

	{
		cout<<"Exception :"<<ex.what()<<endl;
	}
}