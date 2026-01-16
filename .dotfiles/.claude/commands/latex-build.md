Build the LaTeX project and generate the PDF.

Run pdflatex with bibtex to compile main.tex:

1. Run `pdflatex -interaction=nonstopmode main.tex` (first pass)
2. Run `bibtex main` (process bibliography)
3. Run `pdflatex -interaction=nonstopmode main.tex` (second pass)
4. Run `pdflatex -interaction=nonstopmode main.tex` (third pass for references)

Report any errors or warnings from the build process.
