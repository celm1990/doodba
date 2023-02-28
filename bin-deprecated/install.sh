#!/bin/bash
# Notice that this file is only used in odoo v7-10
set -ex

reqs=https://raw.githubusercontent.com/$ODOO_SOURCE/$ODOO_VERSION/requirements.txt
if [ "$ODOO_VERSION" == "7.0" ]; then
    # V7 has no requirements file, but almost matches v8
    reqs=https://raw.githubusercontent.com/$ODOO_SOURCE/8.0/requirements.txt
    # These are the only differences
    pip install python-chart 'pywebdav<0.9.8'
fi
apt_deps="python-dev build-essential"
apt-get update

# lxml
#apt_deps="$apt_deps libxml2-dev libxslt1-dev"
# Pillow
#apt_deps="$apt_deps libjpeg-dev libfreetype6-dev
#    liblcms2-dev libtiff5-dev tk-dev tcl-dev"
# psutil
#apt_deps="$apt_deps linux-headers-amd64"
# psycopg2
#apt_deps="$apt_deps libpq-dev"
# python-ldap
#apt_deps="$apt_deps libldap2-dev libsasl2-dev"

apt-get install -y --no-install-recommends $apt_deps

# Download requirements file to be able to patch it
curl -SLo /tmp/requirements.txt $reqs
reqs=/tmp/requirements.txt

if [ "$ODOO_VERSION" == "8.0" ]; then
    # Packages already installed that conflict with others
    sed -ir 's/pyparsing|six/#\0/' $reqs
    # Extra dependencies for Odoo at runtime
    apt-get install -y --no-install-recommends file
    # Extra dependencies for 'document' (doc & pdf support)
    apt-get install -y --no-install-recommends antiword poppler-utils
    # Extra dependencies for Workflow reports
    apt-get install -y --no-install-recommends graphviz ghostscript
fi

# Build and install Odoo dependencies with pip
#pip install --requirement $reqs
if [ "$ODOO_VERSION" == "9.0" -o "$ODOO_VERSION" == "10.0" ]; then
    pip install watchdog
fi
if [ "$ODOO_VERSION" == "10.0" ]; then
    pip install astor
fi

pip install unicodecsv \
        "Babel==2.3.4" \
        "Jinja2==2.8" \
        "MarkupSafe==0.23" \
        "pillow==3.4.1" \
        "Python-Chart==1.39" \
        "PyYAML==3.12" \
        "Werkzeug==0.11.11" \
        "argparse==1.2.1" \
        "decorator==4.0.10" \
        "docutils==0.12" \
        "gevent==1.1.2" \
        "greenlet==0.4.10" \
        "jcconv==0.2.3" \
        "lxml==3.4.0" \
        "mock==2.0.0 " \
        "passlib==1.6.5" \
        "psutil==1.2.1" \
        "psycogreen==1.0" \
        "psycopg2==2.7.3.1" \
        "pyPdf==1.13" \
        "pydot==1.2.3" \
        "pyparsing==2.1.10" \
        "pyserial==3.1.1" \
        "python-dateutil==2.5.3" \
        "python-ldap==2.4.15" \
        "python-openid==2.2.5" \
        "pytz==2016.7" \
        "pyusb==1.0.0" \
        "qrcode==5.3" \
        "reportlab==3.3.0" \
        "requests==2.11.1" \
        "six==1.10.0" \
        unittest2 \
        "vatnumber==1.2" \
        "vobject==0.9.3" \
        "wsgiref==0.1.2" \
        "xlwt==1.1.2" \
        "XlsxWriter==0.9.3" \
        "git+https://github.com/aeroo/aeroolib@b591d23c98990fc358b02b3b78d46290eadb7277" \
        pysftp \
        num2words \
        recaptcha-client \
        suds \
        "cryptography==3.3" \
        "git+https://github.com/celm1990/python-xmlsig" \
        "xades==0.2.1" \
        "pyopenssl==19.1.0" \
        pyBarcode \
        python-utils \
        utils \
        python-docx \
        "Markdown==2.0.1" \
        "setuptools==33.1.1" \
        "bcrypt==3.1.6" \
        "paramiko==2.4.2" \
        "xlrd==1.0.0" \
        "ofxparse==0.16" \
        "suds-jurko==0.6" \
        "genshi==0.6" \
        psycopg2-binary \

# Remove all installed garbage
#apt-get -y purge $apt_deps
#apt-get -y autoremove
#rm -Rf /var/lib/apt/lists/* /tmp/* || true
