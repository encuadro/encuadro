#include <iostream>
#include <fstream>
using namespace std;

#include "epnp.h"

const double uc = 320;
const double vc = 240;
const double fu = 800;
const double fv = 800;


// MtM takes more time than 12x12 opencv SVD with about 180 points and more:

const int n = 10;
const double noise = 10;

double rand(double min, double max)
{
  return min + (max - min) * double(rand()) / RAND_MAX;
}

void random_pose(double R[3][3], double t[3])
{
  const double range = 1;

  double phi   = rand(0, range * 3.14159 * 2);
  double theta = rand(0, range * 3.14159);
  double psi   = rand(0, range * 3.14159 * 2);

  R[0][0] = cos(psi) * cos(phi) - cos(theta) * sin(phi) * sin(psi);
  R[0][1] = cos(psi) * sin(phi) + cos(theta) * cos(phi) * sin(psi);
  R[0][2] = sin(psi) * sin(theta);

  R[1][0] = -sin(psi) * cos(phi) - cos(theta) * sin(phi) * cos(psi);
  R[1][1] = -sin(psi) * sin(phi) + cos(theta) * cos(phi) * cos(psi);
  R[1][2] = cos(psi) * sin(theta);

  R[2][0] = sin(theta) * sin(phi);
  R[2][1] = -sin(theta) * cos(phi);
  R[2][2] = cos(theta);

  t[0] = 0.0f;
  t[1] = 0.0f;
  t[2] = 6.0f;
}

void random_point(double & Xw, double & Yw, double & Zw)
{
  double theta = rand(0, 3.14159), phi = rand(0, 2 * 3.14159), R = rand(0, +2);

  Xw =  sin(theta) * sin(phi) * R;
  Yw = -sin(theta) * cos(phi) * R;
  Zw =  cos(theta) * R;
}

void project_with_noise(double R[3][3], double t[3],
			double Xw, double Yw, double Zw,
			double & u, double & v)
{
  double Xc = R[0][0] * Xw + R[0][1] * Yw + R[0][2] * Zw + t[0];
  double Yc = R[1][0] * Xw + R[1][1] * Yw + R[1][2] * Zw + t[1];
  double Zc = R[2][0] * Xw + R[2][1] * Yw + R[2][2] * Zw + t[2];

  double nu = rand(-noise, +noise);
  double nv = rand(-noise, +noise);
  u = uc + fu * Xc / Zc + nu;
  v = vc + fv * Yc / Zc + nv;
}

int main(int /*argc*/, char ** /*argv*/)
{
  epnp PnP;

  srand(time(0));

  PnP.set_internal_parameters(uc, vc, fu, fv);
  PnP.set_maximum_number_of_correspondences(n);

  double R_true[3][3], t_true[3];
  random_pose(R_true, t_true);

  PnP.reset_correspondences();
  for(int i = 0; i < n; i++) {
    double Xw, Yw, Zw, u, v;

    random_point(Xw, Yw, Zw);

    project_with_noise(R_true, t_true, Xw, Yw, Zw, u, v);
    PnP.add_correspondence(Xw, Yw, Zw, u, v);
  }

  double R_est[3][3], t_est[3];
  double err2 = PnP.compute_pose(R_est, t_est);
  double rot_err, transl_err;

  PnP.relative_error(rot_err, transl_err, R_true, t_true, R_est, t_est);
  cout << ">>> Reprojection error: " << err2 << endl;
  cout << ">>> rot_err: " << rot_err << ", transl_err: " << transl_err << endl;
  cout << endl;
  cout << "'True reprojection error':"
       << PnP.reprojection_error(R_true, t_true) << endl;
  cout << endl;
  cout << "True pose:" << endl;
  PnP.print_pose(R_true, t_true);
  cout << endl;
  cout << "Found pose:" << endl;
  PnP.print_pose(R_est, t_est);

  return 0;
}
