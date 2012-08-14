#include <vtkVersion.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkVRMLImporter.h>
#include <vtkDataSet.h>
#include <vtkActorCollection.h>
#include <vtkPolyData.h>
#include <vtkPolyDataMapper.h>
#include <vtkPolyDataNormals.h>
#include <vtkActor.h>
#include <vtkSmartPointer.h>
 
int main ( int argc, char *argv[])
{
  if(argc != 2)
    {
    std::cout << "Required arguments: Filename" << std::endl;
    return EXIT_FAILURE;
    }
 
  std::string filename = argv[1];
  std::cout << "Reading " << filename << std::endl;
 
  // VRML Import
  vtkSmartPointer<vtkVRMLImporter> importer = 
    vtkSmartPointer<vtkVRMLImporter>::New();
  importer->SetFileName ( filename.c_str() );
  importer->Read();
  importer->Update();
 
  // Convert to vtkDataSet
  vtkDataSet* pDataset;
  vtkActorCollection* actors = importer->GetRenderer()->GetActors();
  actors->InitTraversal();
  pDataset = actors->GetNextActor()->GetMapper()->GetInput();
 
  // Convert to vtkPolyData
  vtkPolyData *polyData = vtkPolyData::SafeDownCast ( pDataset );
#if VTK_MAJOR_VERSION <= 5
  polyData->Update();
#endif
  // Visualize
  vtkSmartPointer<vtkPolyDataMapper> solidMapper = 
    vtkSmartPointer<vtkPolyDataMapper>::New();
#if VTK_MAJOR_VERSION <= 5
  solidMapper->SetInput(polyData);
#else
  solidMapper->SetInputData(polyData);
#endif
  solidMapper->ScalarVisibilityOff();
 
  vtkSmartPointer<vtkActor> solidActor = 
    vtkSmartPointer<vtkActor>::New();
  solidActor->SetMapper ( solidMapper );
 
  vtkSmartPointer<vtkRenderer> renderer = 
    vtkSmartPointer<vtkRenderer>::New();
  vtkSmartPointer<vtkRenderWindow> renderWindow = 
    vtkSmartPointer<vtkRenderWindow>::New();
  renderWindow->AddRenderer(renderer);
 
  vtkSmartPointer<vtkRenderWindowInteractor> renderWindowInteractor = 
    vtkSmartPointer<vtkRenderWindowInteractor>::New();
  renderWindowInteractor->SetRenderWindow(renderWindow);
 
  renderer->AddActor(solidActor);
  renderWindow->Render();
  renderWindowInteractor->Start();
 
  return EXIT_SUCCESS;
}
