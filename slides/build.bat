SET OUT=slides

pandoc --slide-level 2 -V links-as-notes -V theme=bjeldbak -V aspectratio=169 --template=custom.beamer --toc -t beamer %OUT%.md -o %OUT%.pdf

::pandoc --slide-level 2 -V links-as-notes -V theme=bjeldbak -V aspectratio=169 --template=custom.beamer --toc -t beamer %OUT%.md -o %OUT%.tex

::pdfnup %OUT%.pdf --nup 2x3 --no-landscape --keepinfo --paper A4 --frame true --scale 0.9 --suffix "nup"