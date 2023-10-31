# ParaView - Vector graphics editor

ParaView is a free and open-source vector graphics editor used
to create vector images,
primarily in Scalable Vector Graphics (SVG) format.

* Website : https://www.paraview.org/
* Wikipedia : https://en.wikipedia.org/wiki/ParaView

* Download : https://www.paraview.org/download/



wget https://www.paraview.org/files/listing.txt

EXE:=$(https://www.paraview.org/files/listing.txt | grep '\.msi[[:space:]]' | egrep -v -- '-(RC[[:digit:]]*|MPI)-' | awk '{print $1}' | sort | head -1)


VERSION:=$(cat listing.txt | cut -f 2 -d '/' | grep '^v' | sed -e 's/^v//;' | uniq | sort  -V | tail -1)
