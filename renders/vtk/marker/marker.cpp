//http://www.vtk.org/Wiki/VTK/Examples/Cxx/GeometricObjects/Plane
//http://www.vtk.org/Wiki/VTK/Examples/Cxx/IO/WritePNG

#include <vtkVersion.h>
#include <vtkPlaneSource.h>
#include <vtkPolyData.h>
#include <vtkSmartPointer.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkCamera.h>

int verbose = 1;
 
int main(int argc, char *argv[])
{
	// Create a plane
	vtkSmartPointer<vtkPlaneSource> planeSource = vtkSmartPointer<vtkPlaneSource>::New();
	planeSource->SetCenter(0.0, 0.0, 1.0);
	planeSource->SetNormal(0.0, 0.0, -1.0);
  //planeSource->SetPoint1(0.5, 0.0, 0.0);
  //planeSource->SetPoint2(0.0, 0.5, 0.0);
	planeSource->Update();

	if (verbose) 
	{
		double *pt1 = planeSource->GetPoint1();
		printf("pt1: %f %f\n", pt1[0],pt1[1]);
		double *pt2 = planeSource->GetPoint2();
		printf("pt2: %f %f\n", pt2[0],pt2[1]);
	}
 
	vtkPolyData* plane = planeSource->GetOutput();
 
	// Create a mapper and actor
	vtkSmartPointer<vtkPolyDataMapper> mapper = vtkSmartPointer<vtkPolyDataMapper>::New();
#if VTK_MAJOR_VERSION <= 5
  mapper->SetInput(plane);
#else
  mapper->SetInputData(plane);
#endif
 
	vtkSmartPointer<vtkActor> actor = vtkSmartPointer<vtkActor>::New();
	actor->SetMapper(mapper);
 
	// Create a renderer, render window and interactor
	vtkSmartPointer<vtkRenderer> renderer = vtkSmartPointer<vtkRenderer>::New();
	vtkSmartPointer<vtkRenderWindow> renderWindow =
	vtkSmartPointer<vtkRenderWindow>::New();
	renderWindow->AddRenderer(renderer);
	vtkSmartPointer<vtkRenderWindowInteractor> renderWindowInteractor = vtkSmartPointer<vtkRenderWindowInteractor>::New();
  renderWindowInteractor->SetRenderWindow(renderWindow);
 
	// Add the actors to the scene
	renderer->AddActor(actor);
	renderer->SetBackground(.5,.5,.5); // Background color dark blue
 
 	// Configure camera
	vtkSmartPointer<vtkCamera> camera = vtkSmartPointer<vtkCamera>::New();
	camera->SetViewAngle(50); //fov
	camera->SetFocalPoint(0,0,1); //set up initial view orientation
	camera->SetPosition(0,0,0);
	//double l=1000;
	//double d=700;
	//camera->SetViewUp(0,-1,0);
	//camera->SetDistance(l);
	renderWindow->SetSize(480, 359);
	renderer->SetActiveCamera(camera);
 
	// Render and interact
	renderWindow->Render();
	renderWindowInteractor->Start();
  
	vtkSmartPointer<vtkPNGWriter> writer = vtkSmartPointer<vtkPNGWriter>::New();
	writer->SetFileName("output.png");
	writer->SetInputConnection(renderWindow->GetOutputPort());
	writer->Write();
 
  return EXIT_SUCCESS;
}
