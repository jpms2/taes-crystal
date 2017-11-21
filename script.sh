#!/bin/bash
 
RubyVERSION=$2
if [[ "$RubyVERSION" = "2.0.0" ]]; then
	rvm install $RubyVERSION --disable-binary
else
	rvm install $RubyVERSION
fi
source ~/.rvm/scripts/rvm
type rvm | head -n 1
a=$1; a="${a#*/}";a="${a#*/}";a="${a#*/}";a="${a#*/}"
if [[ ${a%.*} = "whitehall" ]]; then
rvm use "2.2.3"
else
  if [[ ${a%.*} = "RapidFTR" ]]; then
    rvm use "2.1.2"
  else
    if [[ ${a%.*} = "CBA" ]]; then
	rvm use "2.3.0"
    else
        rvm use $RubyVERSION
    fi
  fi
fi

gem install bundler
sudo su -c '/etc/init.d/postgresql restart'
sudo su -c '/etc/init.d/mysql restart'

cd "${a%.*}"

if [[ ${a%.*} = "WebsiteOne" ]]; then
  wget https://github.com/AgileVentures/setup-scripts/raw/develop/scripts/rails_setup.sh
HEADLESS=true WITH_PHANTOMJS=true REQUIRED_RUBY=2.3.1 source rails_setup.sh

else
  if [[ ${a%.*} = "otwarchive" || ${a%.*} = "WebsiteOne" ]]; then
    gem install bundler
  fi
  if [[ ${a%.*} = "RapidFTR" ]]; then
    rake sunspot:solr:start
    rake app:reset
  fi

  if [[ ${a%.*} = "otwarchive" ]]; then
    RAILS_ENV=test bundle exec rake db:drop db:setup db:migrate
  fi

  if [[ ${a%.*} = "one-click-orgs" ]]; then 
    bundle exec rake oco:generate_config
  fi
  if [[ ${a%.*} = "wpcc" ]]; then
    gem install bundler
    cd ..
    cd dough
    bower link
    cd ..
    cd ${a%.*}
    bower link dough
  fi

  bundle install
  if [[ ${a%.*} = "whitehall" || ${a%.*} = "solar" ]]; then
    RAILS_ENV=test bundle exec rake db:setup
  else
    if [[ ${a%.*} != "otwarchive" ]]; then
      if [[ ${a%.*} != "RapidFTR" || ${a%.*} != "wpcc" ]]; then
        RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
      fi
    fi
  fi
fi
RAILS_ENV=test bundle exec cucumber
