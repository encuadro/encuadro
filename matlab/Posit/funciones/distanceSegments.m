function dij = distanceSegments(li,lj)
%dij = distanceSegments(li,lj)
%
% 2da medida de distancia entre l??neas planteada en la secci??n 5 del paper 
% "Simultaneous pose and correspondance determination using line features".
% Daniel Dementhon.
%
% Entrada:
% li : 4-vector conteniendo las coordenadas de los extremos del segmento. 
% lj : 4-vector conteniendo las coordenadas de los extremos del segmento.
%
% li, lj son de la forma: [ x1 y1 x2 y2 ] 
%
% Devuelve:
% dij: escalar medida de distancia. Definida como
%	   dij = Dtheta(li,lj) + rho d(li,lj) 
% en donde rho es un factor de escala.

rho = 0.2;						% scale factor

% vectores de direccion: v = [dx ; dy]
vi = [li(3)-li(1); li(4)-li(2)];	
vj = [lj(3)-lj(1); lj(4)-lj(2)];

% distancia de cada extremo de li al punto mas cercano de lj.
d1 = distancePointEdge(li(1:2), lj);
d2 = distancePointEdge(li(3:4), lj);
Dij = d1 + d2;					% diferencia en ubicaci??n

% producto escalar: <vi,vj> = |vi|.|vj|.cos(arg(li,lj)); 
cos_arg_lilj = (vi'*vj)./(norm(vi)*norm(vj));
Dtheta = 1-abs(cos_arg_lilj);	% diferencia en orientaci??n

% medida de distancia
dij = Dtheta + rho*Dij;

end