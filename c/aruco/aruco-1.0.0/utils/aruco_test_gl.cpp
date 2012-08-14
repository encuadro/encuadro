#include <iostream>
#include <getopt.h>
#include <fstream>
#include <sstream>
#include <GL/gl.h>
#include <GL/glut.h>
#include "aruco.h"
using namespace cv;
using namespace aruco;

string TheInputVideo;
string TheIntrinsicFile;
bool The3DInfoAvailable=false;
bool isIntrinsicFileYAML=false;
float TheMarkerSize=-1;
MarkerDetector PPDetector;
VideoCapture TheVideoCapturer;
vector<Marker> TheMarkers;
Mat TheInputImage,TheUndInputImage,TheResizedImage;
CameraParameters TheCameraParams;
Size TheGlWindowSize;
bool TheCaptureFlag=true;
bool readIntrinsicFile(string TheIntrinsicFile,Mat & TheIntriscCameraMatrix,Mat &TheDistorsionCameraParams,Size size);
void readArguments ( int argc,char **argv );
void usage();
void vDrawScene();
void vIdle();
void vResize( GLsizei iWidth, GLsizei iHeight );
void vMouse(int b,int s,int x,int y);
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
		readArguments (argc,argv);
		if (TheIntrinsicFile==""){cerr<<"-f option required"<<endl;return -1;}
		if (TheMarkerSize==-1){cerr<<"-s option required"<<endl;return -1;}
								 //read from camera
		if (TheInputVideo=="") TheVideoCapturer.open(0);
		else TheVideoCapturer.open(TheInputVideo);
		if (!TheVideoCapturer.isOpened())
		{
			cerr<<"Could not open video"<<endl;
			return -1;

		}

		//read first image
		TheVideoCapturer>>TheInputImage;
		//read camera paramters if passed
		if (isIntrinsicFileYAML)
		  TheCameraParams.readFromXMLFile(TheIntrinsicFile);
		else
		  TheCameraParams.readFromFile(TheIntrinsicFile);
		TheCameraParams.resize(TheInputImage.size());

		glutInit(&argc, argv);
		glutInitWindowPosition( 0, 0);
		glutInitWindowSize(TheInputImage.size().width,TheInputImage.size().height);
		glutInitDisplayMode( GLUT_RGB | GLUT_DEPTH | GLUT_DOUBLE );
		glutCreateWindow( "AruCo" );
		glutDisplayFunc( vDrawScene );
		glutIdleFunc( vIdle );
		glutReshapeFunc( vResize );
		glutMouseFunc(vMouse);
		glClearColor( 0.0, 0.0, 0.0, 1.0 );
		glClearDepth( 1.0 );
		TheGlWindowSize=TheInputImage.size();
		vResize(TheGlWindowSize.width,TheGlWindowSize.height);
		glutMainLoop();

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

void vMouse(int b,int s,int x,int y)
{
    if (b==GLUT_LEFT_BUTTON && s==GLUT_DOWN) {
      TheCaptureFlag=!TheCaptureFlag;
    }

}

/************************************
 *
 *
 *
 *
 ************************************/
void axis(float size)
{
    glColor3f (1,0,0 );
    glBegin(GL_LINES);
    glVertex3f(0.0f, 0.0f, 0.0f); // origin of the line
    glVertex3f(size,0.0f, 0.0f); // ending point of the line
    glEnd( );

    glColor3f ( 0,1,0 );
    glBegin(GL_LINES);
    glVertex3f(0.0f, 0.0f, 0.0f); // origin of the line
    glVertex3f( 0.0f,size, 0.0f); // ending point of the line
    glEnd( );


    glColor3f (0,0,1 );
    glBegin(GL_LINES);
    glVertex3f(0.0f, 0.0f, 0.0f); // origin of the line
    glVertex3f(0.0f, 0.0f, size); // ending point of the line
    glEnd( );


}
/************************************
 *
 *
 *
 *
 ************************************/
void vDrawScene()
{
	if (TheResizedImage.rows==0) //prevent from going on until the image is initialized
	  return;
	///clear
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
	///draw image in the buffer
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0, TheGlWindowSize.width, 0, TheGlWindowSize.height, -1.0, 1.0);
	glViewport(0, 0, TheGlWindowSize.width , TheGlWindowSize.height);
	glDisable(GL_TEXTURE_2D);
	glPixelZoom( 1, -1);
	glRasterPos3f( 0, TheGlWindowSize.height  - 0.5, -1.0 );
	glDrawPixels ( TheGlWindowSize.width , TheGlWindowSize.height , GL_RGB , GL_UNSIGNED_BYTE , TheResizedImage.ptr(0) );
	///Set the appropriate projection matrix so that rendering is done in a enrvironment
	//like the real camera (without distorsion)
	glMatrixMode(GL_PROJECTION);
	double proj_matrix[16];
	MarkerDetector::glGetProjectionMatrix(TheCameraParams,TheInputImage.size(),TheGlWindowSize,proj_matrix,0.05,10);
	glLoadIdentity();
	glLoadMatrixd(proj_matrix);

	//now, for each marker,
	double modelview_matrix[16];
	for(unsigned int m=0;m<TheMarkers.size();m++)
	{
		TheMarkers[m].glGetModelViewMatrix(modelview_matrix);
		glMatrixMode(GL_MODELVIEW);
		glLoadIdentity();
		glLoadMatrixd(modelview_matrix);


		axis(TheMarkerSize);

		glColor3f(1,0.4,0.4);
		glTranslatef(0, TheMarkerSize/2,0);
		glPushMatrix();
 		glutWireCube( TheMarkerSize );

		glPopMatrix();
	}

	glutSwapBuffers();

}


/************************************
 *
 *
 *
 *
 ************************************/
void vIdle()
{
  if(TheCaptureFlag){
	//capture image
	TheVideoCapturer.grab();
	TheVideoCapturer.retrieve( TheInputImage);
	TheUndInputImage.create(TheInputImage.size(),CV_8UC3);
	//transform color that by default is BGR to RGB because windows systems do not allow reading BGR images with opengl properly
	cv::cvtColor(TheInputImage,TheInputImage,CV_BGR2RGB);
	//remove distorion in image
	cv::undistort(TheInputImage,TheUndInputImage, TheCameraParams.CameraMatrix, TheCameraParams.Distorsion);
	//detect markers
	PPDetector.detect(TheUndInputImage,TheMarkers, TheCameraParams.CameraMatrix,Mat(),TheMarkerSize);
	//resize the image to the size of the GL window
	cv::resize(TheUndInputImage,TheResizedImage,TheGlWindowSize);
  }
  glutPostRedisplay();
}


/************************************
 *
 *
 *
 *
 ************************************/
void vResize( GLsizei iWidth, GLsizei iHeight )
{
	TheGlWindowSize=Size(iWidth,iHeight);
	//not all sizes are allowed. OpenCv images have padding at the end of each line in these that are not aligned to 4 bytes
	if (iWidth*3%4!=0){
	  iWidth+=iWidth*3%4;//resize to avoid padding
	  vResize(iWidth,TheGlWindowSize.height);
	}
	else{
	  //resize the image to the size of the GL window
	  if (TheUndInputImage.rows!=0)
	    cv::resize(TheUndInputImage,TheResizedImage,TheGlWindowSize);
	}
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
	cout<<"-f <file>: if you have calibrated your camera, pass calibration information here so as to be able to get 3D marker info"<<endl;
	cout<<"-y <file.yml>: if you have calibrated your camera in yml format as provided by the calibration.cpp aplication in OpenCv >= 2.2"<<endl;
	cout<<"-s <size>: size of the marker's sides (expressed in meters!)"<<endl;

}


/************************************
 *
 *
 *
 *
 ************************************/
static const char short_options [] = "hi:f:s:y:";

static const struct option
long_options [] =
{
	{ "help",           no_argument,   NULL,                 'h' },
	{ "input",     required_argument,   NULL,           'i' },
	{ "YAMLFile",     required_argument,   NULL,           'y' },
	{ "intFile",     required_argument,   NULL,           'f' },
	{ "size",     required_argument,   NULL,           's' },

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
			default:
				usage ();
				exit ( EXIT_FAILURE );
		};
	}

}
