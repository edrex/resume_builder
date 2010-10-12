author = Eric Drechsel
logo = pdxhub
logourl = http://wiki.pdxhub.org/operations

n = eric_drechsel
f = resume_$(n)
products = $(f).pdf $(f).html $(f)_email.html 
media = resume.css $(logo).png
cmd = pandoc --template template.html -V author:'$(author)' -V logourl:'$(logourl)' -V logoimg:'$(logoimg)' -V logoalt:'$(logo)'

all: $(products)
$(f).pdf: $(f)_email.html
	./wkhtmltopdf -T 0 -L 0 -R 0 -s Letter $< $@
$(f).html: logoimg := pdxhub.png
$(f).html: css := <style type='text/css' src='resume.css'/> 
$(f).html: resume.md template.html
	$(cmd) --email-obfuscation=references -c resume.css $< > $@
$(f)_email.html: logoimg = data:data:image/png;base64,$(shell base64 -w 0 $(logo).png)
$(f)_email.html: resume.md template.html $(f)_email.header.tmp
	$(cmd) --email-obfuscation=none -H $(f)_email.header.tmp $< > $@
$(f)_email.header.tmp: resume.css
	echo "<style type='text/css'>`cat resume.css`</style>" > $@
clean:
	rm *.tmp $(f).html $(f)_email.html
push: all
	scp $(products) $(media) eric@goober.pdxhub.org:/home/eric/pages
