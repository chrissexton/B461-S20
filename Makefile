OUTPUT:=html/
#PROJECT:=$$(basename ${CURDIR})
PROJECT:="B461"
SOURCES:=$(wildcard *.adoc)
	
all: wiki

gen: B461.toml
	semestergen B461.toml

wiki: index.adoc readme.adoc schedule.adoc assignments.adoc
	touch $?
	wiki.adoc -out="docs" -media="img,code,resources,students" -exclude="admin,tests,code,students,assn_unpub,notes_unpub,docs"

serve: all
	devd -ol $(OUTPUT)

clean:
	find . -name _index.adoc -exec rm {} \; && rm -r $(OUTPUT)

rsync: wiki
	rsync -a -u -v docs/ cwsexton@mercury.uits.indiana.edu:www/$(PROJECT)/

publish: rsync cso

cso: wiki
	cp -r docs/* ~/www/ius.chrissexton.org/C346/

default: wiki

.PHONY: clean serve wiki pdf
