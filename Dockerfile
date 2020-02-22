
# Se deberia bindear el proyecto a la carpeta /project
FROM node:10
# Add Google Chrome to aptitude's (package manager) sources
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list
# Fetch Chrome's PGP keys for secure installation
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
# Update aptitude's package sources
RUN apt-get -qq update -y
# Install latest Chrome stable, Xvfb packages
RUN apt-get -qq install -y --allow-unauthenticated \
  default-jre \
  google-chrome-stable \
  gtk2-engines-pixbuf \
  imagemagick \
  xfonts-cyrillic \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-base \
  xfonts-scalable \
  x11-apps \
  xvfb
# Launch Xvfb
RUN Xvfb :0 -ac -screen 0 1024x768x24 &
# Export display for Chrome
RUN export DISPLAY=:99
RUN mkdir /project
RUN cd /project
ADD scripts /scripts
RUN chmod +x /scripts/*
RUN npm install -g protractor
RUN webdriver-manager update
RUN export TARGET_ENV=TST
# Install AngularJS CLI exclusively
# Add --unsafe-perm to resolve problems with node-gyp infinite loop on Docker
#RUN npm install --silent --unsafe-perm -g @angular/cli@1.1.2
    # Install remaining project dependencies
#RUN npm install --silent
    # Download Selenium server JAR, drivers for Chrome
#RUN node ./node_modules/.bin/webdriver-manager update