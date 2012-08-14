#include "board.h"
#include <cstdio>
#include <opencv/cv.h>
#include <opencv/highgui.h>
using namespace std;
using namespace cv;
int main(int argc,char **argv)
{
try{
  if (argc<4){
    cerr<<"Usage: X:Y boardImage.png boardConfiguration.abc [FirstMakerId(0)] [pixSize]"<<endl;
    return -1;
  }
 int XSize,YSize;
 if (sscanf(argv[1],"%d:%d",&XSize,&YSize)!=2) {cerr<<"Incorrect X:Y specification"<<endl;return -1;}
 int pixSize=100;
 int FirstMakerId=0;
 if (argc>=5) FirstMakerId=atoi(argv[4]);
 if (argc>=6) pixSize=atoi(argv[5]);
 aruco::BoardConfiguration BInfo;
 Mat BoardImage=aruco::Board::createBoardImage(Size(XSize,YSize), pixSize,pixSize*0.2, FirstMakerId,BInfo);
 imwrite(argv[2],BoardImage);
 BInfo.saveToFile(argv[3]);
  
    
}
catch(std::exception &ex)
{
    cout<<ex.what()<<endl;
}

}

