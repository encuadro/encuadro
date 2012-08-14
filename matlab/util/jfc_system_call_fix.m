function fix=jfc_system_call_fix()


if (strcmp(computer,'GLNX86') || strcmp(computer,'GLNXA64') )
	fix='export LD_LIBRARY_PATH=/usr/lib:/usr/local/lib:/home/juan/juanc/soft/libs/lib:$LD_LIBRARY_PATH ; export XML_OUTPUT=2';
	
elseif (strcmp(computer,'MACI') || strcmp(computer,'MACI64'))
	%fix=['export XML_OUTPUT=2 ; export DYLD_LIBRARY_PATH=:/usr/lib:/usr/local/Cellar/fftw/3.3/lib/:/home/juan/juanc/soft/libs/lib:/usr/X11/lib:' getenv('DYLD_LIBRARY_PATH') ' ; '];
	fix=['export XML_OUTPUT=2 ; export DYLD_LIBRARY_PATH=/usr/lib:/usr/local/Cellar/fftw/3.3/lib:/home/juan/juanc/soft/libs/lib'];
	fix=[fix ' ; ' 'export PATH=$PATH:/usr/local/bin:/Users/juan/juanc/develop/codigo/tmaps/trunk/bin/:/Users/juan/juanc/develop/qnm/trunk'];
else
	error('unknown system');
end

